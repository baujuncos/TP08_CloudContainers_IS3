# TP8 - Implementación de Contenedores en la Nube

## 📋 Resumen Ejecutivo

Este documento detalla la implementación del TP8 usando una arquitectura de contenedores cloud-native con las siguientes tecnologías:

- **Container Registry**: GitHub Container Registry (ghcr.io)
- **CI/CD**: GitHub Actions
- **Hosting QA**: Render.com (plan gratuito)
- **Hosting PROD**: Render.com (plan starter)
- **Base de Datos**: SQLite con volúmenes persistentes

## 🏗️ Arquitectura Implementada

### Diagrama de Flujo CI/CD

```
GitHub Repository (main/master)
    ↓
GitHub Actions Pipeline
    ↓
[1] Build & Test
    ├─ npm install
    ├─ npm run build
    └─ npm test
    ↓
[2] Docker Build & Push
    ├─ Build Docker image
    ├─ Tag with version/SHA
    └─ Push to ghcr.io
    ↓
[3] Deploy to QA (Automatic)
    ├─ Pull image from ghcr.io
    ├─ Deploy to Render QA
    └─ Smoke tests
    ↓
[4] Manual Approval Gate
    ↓
[5] Deploy to PROD (Manual)
    ├─ Pull image from ghcr.io
    ├─ Deploy to Render PROD
    └─ Smoke tests
```

## 🔧 Componentes Implementados

### 1. Dockerfile

**Ubicación**: `/Dockerfile`

**Características**:
- **Multi-stage build** para optimizar tamaño de imagen
- Stage 1 (builder): Compila dependencias nativas (SQLite3)
- Stage 2 (production): Imagen final optimizada
- **Security**: Ejecuta como usuario no-root (`node`)
- **Health checks**: Endpoint `/api/health` monitoreado
- **Volúmenes**: Directorios para datos y uploads

**Optimizaciones**:
- Uso de node:18-alpine (imagen base pequeña)
- Instalación de dependencias de producción
- .dockerignore para excluir archivos innecesarios
- Cache de capas de Docker

### 2. GitHub Actions Workflow

**Ubicación**: `.github/workflows/ci-cd.yml`

**Jobs Implementados**:

#### Job 1: Build and Test
- Checkout del código
- Setup de Node.js 18
- Instalación de dependencias
- Ejecución de build
- Ejecución de tests unitarios e integración

#### Job 2: Build and Push Docker Image
- Setup de Docker Buildx
- Login a GitHub Container Registry
- Extracción de metadata (tags, labels)
- Build de imagen Docker
- Push a ghcr.io con múltiples tags:
  - `branch-sha`: Tag único por commit
  - `latest`: Para rama principal
  - `ref`: Nombre de la rama

#### Job 3: Deploy to QA
- Trigger automático después de build exitoso
- Solo para rama main/master
- Deploy mediante webhook de Render
- Smoke tests automáticos
- Environment: `qa`

#### Job 4: Deploy to Production
- Requiere aprobación manual
- Solo después de QA exitoso
- Deploy mediante webhook de Render
- Smoke tests automáticos
- Environment: `production`

### 3. Configuración de Render

**Ubicación**: `/render.yaml`

**Servicios Configurados**:

#### QA Environment
```yaml
- Plan: Free
- Región: Oregon
- Instancias: 1
- RAM: 512 MB
- CPU: Compartida
- Disco: 1 GB persistente
- Auto-deploy: Habilitado
```

#### Production Environment
```yaml
- Plan: Starter ($7/mes)
- Región: Oregon
- Instancias: 1 (escalable)
- RAM: 512 MB
- CPU: Compartida
- Disco: 1 GB persistente
- Auto-deploy: Deshabilitado (requiere aprobación)
```

## 🔐 Gestión de Secretos

### GitHub Secrets Requeridos

| Secret | Descripción | Uso |
|--------|-------------|-----|
| `GITHUB_TOKEN` | Token automático de GitHub | Push a GHCR |
| `RENDER_QA_DEPLOY_HOOK` | Webhook de Render QA | Deploy automático QA |
| `RENDER_PROD_DEPLOY_HOOK` | Webhook de Render PROD | Deploy manual PROD |

### Variables de Entorno

#### QA
```env
NODE_ENV=qa
PORT=3000
DATABASE_PATH=/app/data/database.sqlite
JWT_SECRET=<auto-generado>
RENDER_ENV=qa
```

#### Production
```env
NODE_ENV=production
PORT=3000
DATABASE_PATH=/app/data/database.sqlite
JWT_SECRET=<auto-generado>
RENDER_ENV=production
```

## 📊 Comparación QA vs PROD

| Aspecto | QA | PROD | Justificación |
|---------|-----|------|---------------|
| **Servicio** | Render.com Free | Render.com Starter | Mismo servicio, diferentes recursos |
| **Plan** | Free | Starter ($7/mes) | QA no requiere alta disponibilidad |
| **CPU/Memoria** | 512 MB RAM compartida | 512 MB RAM compartida | Suficiente para la aplicación |
| **Instancias** | 1 | 1 (escalable) | QA no necesita redundancia |
| **Disco** | 1 GB persistente | 1 GB persistente | SQLite con persistencia |
| **Deploy** | Automático | Manual con aprobación | Control en producción |
| **Downtime** | Permitido (spin down) | Minimizado | Free tier tiene sleep mode |
| **Monitoreo** | Básico | Health checks + logs | PROD requiere más observabilidad |
| **Costos** | $0/mes | $7/mes | Costo mínimo para PROD activo 24/7 |

## 🚀 Proceso de Deployment

### Deploy a QA (Automático)

1. Developer hace push a `main`
2. GitHub Actions ejecuta:
   - Build & Test
   - Docker Build & Push
3. Imagen se sube a ghcr.io con tag único
4. Webhook de Render QA se activa
5. Render pull la imagen y deploya
6. Smoke tests validan el deploy
7. QA está listo para testing

### Deploy a PROD (Manual)

1. QA deployment exitoso
2. Se requiere **aprobación manual** en GitHub
3. Reviewer aprueba en GitHub Actions
4. GitHub Actions ejecuta:
   - Webhook de Render PROD
5. Render pull la misma imagen de QA
6. Deploy a producción
7. Smoke tests validan el deploy
8. PROD está actualizado

## 🔄 Versionado de Imágenes

### Estrategia de Tags

```bash
ghcr.io/baujuncos/tp08_cloudcontainers_is3:latest
ghcr.io/baujuncos/tp08_cloudcontainers_is3:main
ghcr.io/baujuncos/tp08_cloudcontainers_is3:main-abc1234
ghcr.io/baujuncos/tp08_cloudcontainers_is3:pr-123
```

**Tags generados automáticamente**:
- `latest`: Última versión de la rama principal
- `{branch}`: Última versión de cada rama
- `{branch}-{sha}`: Tag único por commit (inmutable)
- `pr-{number}`: Para pull requests

**Ventajas**:
- ✅ Rollback fácil a cualquier versión
- ✅ Trazabilidad completa (SHA → Image)
- ✅ Testing de PRs antes de merge

## 📈 Escalabilidad

### Escalabilidad Actual

- **QA**: No requiere escalado (testing limitado)
- **PROD**: Escalado manual aumentando instancias en Render

### Escalabilidad Futura

Si la aplicación crece 10x:

1. **Migrar base de datos**:
   - De SQLite a PostgreSQL/MySQL
   - Usar Railway/Supabase como DBaaS
   - Separar BD de la aplicación

2. **Migrar a orquestación**:
   - De Render a Kubernetes (GKE/EKS/AKS)
   - Implementar auto-scaling horizontal
   - Load balancing automático

3. **Añadir caché**:
   - Redis para sesiones
   - CDN para assets estáticos

4. **Monitoring avanzado**:
   - Prometheus + Grafana
   - ELK Stack para logs
   - APM (New Relic/Datadog)

## 🛡️ Seguridad

### Medidas Implementadas

✅ **Imagen Docker**:
- Usuario no-root
- Imagen base Alpine (menor superficie de ataque)
- Sin secretos hardcodeados

✅ **Secrets Management**:
- GitHub Secrets para credentials
- Environment variables en Render
- JWT_SECRET auto-generado

✅ **Network Security**:
- HTTPS en Render (automático)
- CORS configurado
- Helmet.js para headers seguros

✅ **Application Security**:
- Rate limiting
- BCrypt para passwords
- JWT para autenticación
- Validación de inputs

### Mejoras Futuras

- [ ] Escaneo de vulnerabilidades (Trivy/Snyk)
- [ ] WAF (Web Application Firewall)
- [ ] Secrets en vault (HashiCorp Vault/AWS Secrets Manager)
- [ ] Auditoría de logs

## 💰 Análisis de Costos

### Costos Mensuales

| Componente | Plan | Costo |
|------------|------|-------|
| GitHub Actions | Free tier | $0 (2000 min/mes) |
| GitHub Container Registry | Free | $0 (500 MB) |
| Render QA | Free | $0 (con sleep mode) |
| Render PROD | Starter | $7/mes |
| **TOTAL** | | **$7/mes** |

### Comparación con Alternativas

| Alternativa | Costo Mensual | Pros | Contras |
|-------------|---------------|------|---------|
| **Render (elegida)** | $7 | Simple, HTTPS gratis, persistencia | Sleep mode en free tier |
| Railway | $5 base + uso | Deploy más rápido | Costos variables |
| Fly.io | $0-10 | Global edge, gratis básico | Configuración compleja |
| Heroku | $7-25 | Muy simple | Más caro, menos control |
| Azure Container Instances | $15-30 | Integración Azure | Requiere créditos estudiantiles |

### Optimización de Costos

1. **QA en Free Tier**: Acceptable sleep mode para testing
2. **PROD en Starter**: $7/mes es mínimo para 24/7 uptime
3. **Shared DB**: SQLite evita costos de DB separada
4. **CDN gratis**: Cloudflare para assets estáticos
5. **Monitoreo gratis**: Render dashboard + GitHub Actions logs

## 🔧 Instrucciones de Setup

### 1. Configurar GitHub Container Registry

```bash
# Habilitar GHCR (automático con GitHub Actions)
# Permisos: Settings → Actions → General → Workflow permissions
# ✅ Marcar: "Read and write permissions"
```

### 2. Configurar Render

1. Crear cuenta en [Render.com](https://render.com)
2. Crear dos Web Services:
   - `tiktask-qa` (Free plan)
   - `tiktask-prod` (Starter plan)
3. Configurar cada servicio:
   - Environment: Docker
   - Build: Dockerfile
   - Región: Oregon (más cercana)
4. Configurar variables de entorno en Render dashboard
5. Añadir discos persistentes:
   - Path: `/app/data`
   - Tamaño: 1 GB

### 3. Configurar GitHub Secrets

```bash
# En GitHub: Settings → Secrets and variables → Actions

# Añadir secrets:
1. RENDER_QA_DEPLOY_HOOK
   - Obtener de: Render dashboard → Service → Settings → Deploy Hook
   
2. RENDER_PROD_DEPLOY_HOOK
   - Obtener de: Render dashboard → Service → Settings → Deploy Hook
```

### 4. Configurar GitHub Environments

```bash
# En GitHub: Settings → Environments

# Crear "qa" environment:
- No protection rules (deploy automático)

# Crear "production" environment:
- ✅ Required reviewers (al menos 1)
- ✅ Wait timer: 0 minutes
```

### 5. Ejecutar Pipeline

```bash
# Push a main para activar pipeline
git push origin main

# Monitorear en GitHub: Actions tab
# Aprobar deployment a PROD cuando QA sea exitoso
```

## 🧪 Testing

### Tests Locales

```bash
# Instalar dependencias
npm install

# Ejecutar tests
npm test

# Build local
npm run build

# Ejecutar localmente
npm start
```

### Tests con Docker

```bash
# Build imagen
docker build -t tiktask:local .

# Ejecutar container
docker run -p 3000:3000 \
  -e JWT_SECRET=test-secret \
  -e DATABASE_PATH=/app/data/database.sqlite \
  -v $(pwd)/data:/app/data \
  tiktask:local

# Verificar health
curl http://localhost:3000/api/health
```

### Smoke Tests Automatizados

Los smoke tests se ejecutan automáticamente en el pipeline:

```bash
# Health check
curl https://tiktask-qa.onrender.com/api/health
curl https://tiktask.onrender.com/api/health

# Status esperado: 200 OK
```

## 📝 Logs y Monitoreo

### Ver Logs en Render

1. Dashboard → Service → Logs
2. Live tail habilitado
3. Búsqueda por texto
4. Filtrado por fecha

### Ver Logs en GitHub Actions

1. Repository → Actions
2. Seleccionar workflow run
3. Ver logs de cada job
4. Download logs completos

### Métricas Disponibles

- **Render Dashboard**:
  - CPU usage
  - Memory usage
  - Request count
  - Response times
  - Disk usage

- **GitHub Actions**:
  - Build time
  - Test results
  - Deploy status
  - Artifact sizes

## 🔄 Rollback

### Proceso de Rollback

1. **Identificar versión estable**:
   ```bash
   # Ver imágenes en GHCR
   # GitHub → Packages → tp08_cloudcontainers_is3
   ```

2. **Rollback en Render**:
   - Dashboard → Service → Deploys
   - Click en deploy anterior exitoso
   - Click "Redeploy"

3. **Rollback mediante CI/CD**:
   ```bash
   # Re-ejecutar workflow de versión anterior
   # Actions → Workflow → Re-run jobs
   ```

### Estrategias de Rollback

- **Inmediato**: Redeploy manual en Render (< 2 min)
- **Controlado**: Re-ejecutar pipeline de commit anterior
- **Blue-Green**: Mantener QA con versión anterior mientras PROD se actualiza

## 📚 Recursos y Referencias

### Documentación Oficial

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Render Docs](https://render.com/docs)

### Tutoriales Usados

- Multi-stage Docker builds
- GitHub Actions workflows
- Render deployments
- Container best practices

## 🎯 Decisiones Arquitectónicas Clave

### ¿Por qué GitHub Stack?

✅ **Integración nativa**: Todo en un ecosistema
✅ **Costo**: Completamente gratis para CI/CD y registry
✅ **Simplicidad**: Menos herramientas = menos complejidad
✅ **Documentación**: Excelente y abundante

### ¿Por qué Render?

✅ **Simplicidad**: Deploy en minutos
✅ **HTTPS automático**: Sin configuración
✅ **Free tier generoso**: Perfecto para QA
✅ **Persistencia**: Discos para SQLite
✅ **Documentación**: Clara y práctica

### ¿Por qué mismo servicio QA/PROD?

✅ **Consistencia**: Mismo runtime, menos sorpresas
✅ **Simplicidad**: Un solo servicio que aprender
✅ **Costo-efectivo**: Free tier + starter es muy económico
✅ **Diferenciación**: Por configuración, no por servicio

### ¿Por qué SQLite?

✅ **Simplicidad**: Sin DB externa que administrar
✅ **Costo**: $0 adicionales
✅ **Persistencia**: Con volúmenes funciona bien
✅ **Suficiente**: Para carga baja-media

❌ **Limitaciones conocidas**:
- No apto para alta concurrencia
- No distribuido
- Backups manuales

**Plan de migración**: Si crecemos, migrar a PostgreSQL en Railway/Supabase

## 🏆 Resultados y Aprendizajes

### Desafíos Encontrados

1. **SQLite en contenedores**:
   - Problema: Binarios nativos para Alpine
   - Solución: Multi-stage build con rebuild

2. **Persistencia de datos**:
   - Problema: Contenedores son efímeros
   - Solución: Discos persistentes en Render

3. **Approval gates**:
   - Problema: GitHub Environments configuration
   - Solución: Documentación de setup

### Mejoras Futuras

1. **Monitoreo**: Implementar Prometheus + Grafana
2. **Database**: Migrar a PostgreSQL
3. **Caché**: Añadir Redis
4. **Tests**: E2E tests con Cypress en CI
5. **Security**: Vulnerability scanning automático

### Aprendizajes Clave

✅ **Contenedores**: Entender capas, multi-stage, optimización
✅ **CI/CD**: Pipeline completo con quality gates
✅ **Cloud**: Deploy automatizado, infraestructura como código
✅ **DevOps**: Balance entre automatización y control
✅ **Arquitectura**: Decisiones justificadas con trade-offs

## 📞 Soporte

- **Issues**: GitHub Issues del repositorio
- **Documentación**: Este archivo (TP8_IMPLEMENTATION.md)
- **Guía original**: TP8_consignas.MD

---

**Implementado por**: Belén Treachi y Bautista Juncos
**Fecha**: 2025
**Materia**: Ingeniería de Software 3 - TP8
