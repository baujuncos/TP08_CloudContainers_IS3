# 🚀 Guía de Configuración - TP8 CI/CD Pipeline

Esta guía te ayudará a configurar todo lo necesario para que el pipeline CI/CD funcione correctamente, desplegando tu aplicación TikTask en Render con ambientes QA y Producción separados.

## 📋 Arquitectura Implementada

**Stack:** Opción 1 - GitHub Stack (100% del CI/CD gratis, Render con free tier para QA)

```
GitHub Repository
  → GitHub Actions (CI/CD) - GRATIS
    → Build & Test Backend
    → Build Docker Images (Frontend + Backend)
    → Push to GitHub Container Registry (GHCR) - GRATIS
    → Deploy to Render QA
       ├─ Frontend QA (Free tier)
       └─ Backend QA (Free tier)
    → Approval Gate (Manual)
    → Deploy to Render Production
       ├─ Frontend PROD (Starter - $7/mes)
       └─ Backend PROD (Starter - $7/mes)
```

**Servicios Totales:** 4 servicios
- `tiktask-frontend-qa` (Free)
- `tiktask-backend-qa` (Free)
- `tiktask-frontend-prod` (Starter)
- `tiktask-backend-prod` (Starter)

**Imágenes Docker:** 2 imágenes (reutilizadas en ambos ambientes)
- `ghcr.io/<tu-usuario>/tiktask-frontend:latest`
- `ghcr.io/<tu-usuario>/tiktask-backend:latest`

---

## 📦 Paso 1: Configurar GitHub Container Registry (GHCR)

### 1.1 Verificar que GHCR esté habilitado

El pipeline usa `GITHUB_TOKEN` automático que tiene permisos para escribir en GHCR. No necesitas crear un token especial, pero debes asegurarte de que los paquetes sean visibles.

### 1.2 Hacer las imágenes públicas (Opcional pero recomendado para Render Free)

Después del primer push, ve a:
1. Tu perfil de GitHub → Packages
2. Encuentra `tiktask-backend` y `tiktask-frontend`
3. Click en cada paquete → Package settings
4. En "Danger Zone" → Change visibility → Public

Esto permite que Render pueda descargar las imágenes sin autenticación (requerido para el plan Free).

---

## 🔐 Paso 2: Configurar Secrets en GitHub

Ve a tu repositorio → **Settings** → **Secrets and variables** → **Actions**

### Secrets a crear:

**Para QA:**
- `RENDER_BACKEND_QA_DEPLOY_HOOK`: Deploy hook del servicio backend QA
- `RENDER_FRONTEND_QA_DEPLOY_HOOK`: Deploy hook del servicio frontend QA

**Para Producción:**
- `RENDER_BACKEND_PROD_DEPLOY_HOOK`: Deploy hook del servicio backend PROD
- `RENDER_FRONTEND_PROD_DEPLOY_HOOK`: Deploy hook del servicio frontend PROD

*(Los deploy hooks los obtendrás de Render en el Paso 3)*

---

## 🌐 Paso 3: Configurar Variables en GitHub

En la misma sección → **Variables** tab

### Variables a crear:

**Para QA:**
- `QA_BACKEND_URL`: `https://tiktask-backend-qa.onrender.com`
- `QA_FRONTEND_URL`: `https://tiktask-frontend-qa.onrender.com`

**Para Producción:**
- `PROD_BACKEND_URL`: `https://tiktask-backend-prod.onrender.com`
- `PROD_FRONTEND_URL`: `https://tiktask-frontend-prod.onrender.com`

*(Ajusta los nombres según los que elijas en Render)*

---

## 🎨 Paso 4: Crear Servicios en Render

Necesitas crear 4 servicios en Render (2 para QA, 2 para PROD).

### 4.1 Crear Backend QA

1. Ve a [Render Dashboard](https://dashboard.render.com/) → **New** → **Web Service**
2. Selecciona **Deploy an existing image from a registry**
3. Configura:
   - **Service Name:** `tiktask-backend-qa`
   - **Region:** Oregon (US West)
   - **Image URL:** `ghcr.io/<TU-USUARIO-GITHUB>/tiktask-backend:latest`
   - **Plan:** Free
4. Variables de entorno:
   ```
   NODE_ENV=qa
   PORT=3000
   DATABASE_PATH=/app/data/database.sqlite
   JWT_SECRET=<genera-un-secreto-aleatorio-seguro>
   RENDER_ENV=qa
   ```
5. En **Disk** tab:
   - Name: `tiktask-backend-qa-data`
   - Mount Path: `/app/data`
   - Size: 1 GB
6. En **Settings** → **Health Check Path:** `/api/health`
7. Deploy el servicio
8. Una vez creado, ve a **Settings** → **Deploy Hook** → Copia la URL del deploy hook
9. Guarda este deploy hook como `RENDER_BACKEND_QA_DEPLOY_HOOK` en GitHub Secrets

### 4.2 Crear Frontend QA

1. **New** → **Web Service** → **Deploy an existing image**
2. Configura:
   - **Service Name:** `tiktask-frontend-qa`
   - **Region:** Oregon (US West)
   - **Image URL:** `ghcr.io/<TU-USUARIO-GITHUB>/tiktask-frontend:latest`
   - **Plan:** Free
3. Variables de entorno:
   ```
   BACKEND_URL=https://tiktask-backend-qa.onrender.com
   ```
   ⚠️ **IMPORTANTE:** Usa la URL real de tu backend QA que acabas de crear
4. Deploy el servicio
5. Copia el deploy hook y guárdalo como `RENDER_FRONTEND_QA_DEPLOY_HOOK`

### 4.3 Crear Backend PROD

1. **New** → **Web Service** → **Deploy an existing image**
2. Configura:
   - **Service Name:** `tiktask-backend-prod`
   - **Region:** Oregon (US West)
   - **Image URL:** `ghcr.io/<TU-USUARIO-GITHUB>/tiktask-backend:latest`
   - **Plan:** Starter ($7/mes)
3. Variables de entorno:
   ```
   NODE_ENV=production
   PORT=3000
   DATABASE_PATH=/app/data/database.sqlite
   JWT_SECRET=<genera-un-secreto-diferente-y-mas-seguro>
   RENDER_ENV=production
   ```
4. Disk: Mount `/app/data` con 1 GB
5. Health Check Path: `/api/health`
6. En **Settings** → **Auto-Deploy:** OFF (para tener control manual)
7. Copia el deploy hook → `RENDER_BACKEND_PROD_DEPLOY_HOOK`

### 4.4 Crear Frontend PROD

1. **New** → **Web Service** → **Deploy an existing image**
2. Configura:
   - **Service Name:** `tiktask-frontend-prod`
   - **Region:** Oregon (US West)
   - **Image URL:** `ghcr.io/<TU-USUARIO-GITHUB>/tiktask-frontend:latest`
   - **Plan:** Starter ($7/mes)
3. Variables de entorno:
   ```
   BACKEND_URL=https://tiktask-backend-prod.onrender.com
   ```
4. Auto-Deploy: OFF
5. Copia el deploy hook → `RENDER_FRONTEND_PROD_DEPLOY_HOOK`

---

## 🔑 Paso 5: Configurar GitHub Environments

Para tener aprobación manual antes de producción:

1. Ve a **Settings** → **Environments**
2. Crea environment **QA**:
   - No requiere aprobación
   - Agrega las variables `QA_BACKEND_URL` y `QA_FRONTEND_URL` aquí si prefieres (opcional)
3. Crea environment **Production**:
   - ✅ Enable **Required reviewers**
   - Agrega tu usuario como reviewer
   - Agrega las variables `PROD_BACKEND_URL` y `PROD_FRONTEND_URL` aquí si prefieres (opcional)

---

## 🧪 Paso 6: Probar el Pipeline

### 6.1 Hacer un commit y push

```bash
git add .
git commit -m "Configure CI/CD pipeline for TP8"
git push origin main
```

### 6.2 Verificar GitHub Actions

1. Ve a tu repo → **Actions** tab
2. Deberías ver el workflow "CI/CD - Build, Push to GHCR & Deploy to Render" ejecutándose
3. El workflow:
   - ✅ Ejecuta tests del backend
   - ✅ Construye y pushea imágenes Docker a GHCR
   - ✅ Despliega automáticamente a QA
   - ⏸️ Espera aprobación manual
   - (Después de aprobar) Despliega a Producción

### 6.3 Aprobar despliegue a Producción

1. Cuando el job "deploy-prod" esté en estado "Waiting"
2. Click en el workflow → Click en "Review deployments"
3. Selecciona "Production" → "Approve and deploy"

---

## ✅ Verificación Final

### Verificar imágenes en GHCR
```bash
# Ver tus paquetes
# https://github.com/<tu-usuario>?tab=packages
```

### Verificar servicios en Render
- QA Backend: https://tiktask-backend-qa.onrender.com/api/health
- QA Frontend: https://tiktask-frontend-qa.onrender.com
- PROD Backend: https://tiktask-backend-prod.onrender.com/api/health
- PROD Frontend: https://tiktask-frontend-prod.onrender.com

---

## 🐛 Troubleshooting

### Error: "Failed to pull image from GHCR"
**Solución:** Verifica que las imágenes sean públicas en GitHub Packages.

### Error: "Deploy hook failed"
**Solución:** Verifica que los secrets estén correctamente configurados y que los deploy hooks sean válidos.

### Frontend no puede conectar con Backend
**Solución:** Verifica que la variable `BACKEND_URL` en el frontend apunte a la URL correcta del backend (debe incluir `https://`).

### Backend health check fails
**Solución:** Espera 1-2 minutos después del deploy. Los servicios free de Render pueden tardar en iniciar.

---

## 📊 Resumen de Configuración

### GitHub Secrets (4 total)
- `RENDER_BACKEND_QA_DEPLOY_HOOK`
- `RENDER_FRONTEND_QA_DEPLOY_HOOK`
- `RENDER_BACKEND_PROD_DEPLOY_HOOK`
- `RENDER_FRONTEND_PROD_DEPLOY_HOOK`

### GitHub Variables (4 total)
- `QA_BACKEND_URL`
- `QA_FRONTEND_URL`
- `PROD_BACKEND_URL`
- `PROD_FRONTEND_URL`

### Render Services (4 total)
1. **tiktask-backend-qa** (Free)
   - Image: `ghcr.io/<usuario>/tiktask-backend:latest`
   - Disk: 1GB en `/app/data`
   
2. **tiktask-frontend-qa** (Free)
   - Image: `ghcr.io/<usuario>/tiktask-frontend:latest`
   - Env: `BACKEND_URL=https://tiktask-backend-qa.onrender.com`

3. **tiktask-backend-prod** (Starter - $7/mes)
   - Image: `ghcr.io/<usuario>/tiktask-backend:latest`
   - Disk: 1GB en `/app/data`
   - Auto-Deploy: OFF

4. **tiktask-frontend-prod** (Starter - $7/mes)
   - Image: `ghcr.io/<usuario>/tiktask-frontend:latest`
   - Env: `BACKEND_URL=https://tiktask-backend-prod.onrender.com`
   - Auto-Deploy: OFF

---

## 🎯 Diferencias entre QA y PROD

| Aspecto | QA | PROD |
|---------|----|----- |
| Plan Render | Free | Starter ($7/mes) |
| Auto-Deploy | ON | OFF (manual) |
| Recursos | Limitados | Mejores |
| Variables ENV | NODE_ENV=qa | NODE_ENV=production |
| Aprobación | Automática | Manual (GitHub Environments) |

---

## 📚 Documentación Adicional

- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [GitHub Actions Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Render Deploy Hooks](https://render.com/docs/deploy-hooks)
- [Render Docker Images](https://render.com/docs/deploy-an-image)

---

## ✨ Próximos Pasos (Opcional - Mejoras)

1. **Agregar monitoreo:** Configurar uptime monitoring en Render
2. **Agregar notificaciones:** Slack/Discord notifications en el workflow
3. **Mejorar health checks:** Agregar más endpoints de validación
4. **Database backups:** Configurar backups automáticos del disco de Render
5. **Custom domains:** Agregar dominios personalizados en Render

---

**¡Listo!** 🎉 Ahora tienes un pipeline completo de CI/CD con separación de ambientes QA y Producción.
