# 📸 Guía Visual de Configuración

Esta guía complementa el SETUP_GUIDE.md con ejemplos visuales de cómo debería verse cada configuración.

---

## 🔐 1. GitHub Secrets

### Ubicación
```
Tu Repositorio → Settings → Secrets and variables → Actions → Secrets
```

### Secrets requeridos (4 total)

```
┌─────────────────────────────────────────────┐
│ Repository secrets                          │
├─────────────────────────────────────────────┤
│ RENDER_BACKEND_QA_DEPLOY_HOOK              │
│ Updated 2 days ago                          │
│ [Update] [Remove]                           │
├─────────────────────────────────────────────┤
│ RENDER_FRONTEND_QA_DEPLOY_HOOK             │
│ Updated 2 days ago                          │
│ [Update] [Remove]                           │
├─────────────────────────────────────────────┤
│ RENDER_BACKEND_PROD_DEPLOY_HOOK            │
│ Updated 2 days ago                          │
│ [Update] [Remove]                           │
├─────────────────────────────────────────────┤
│ RENDER_FRONTEND_PROD_DEPLOY_HOOK           │
│ Updated 2 days ago                          │
│ [Update] [Remove]                           │
└─────────────────────────────────────────────┘
```

**Formato de los deploy hooks:**
```
https://api.render.com/deploy/srv-xxxxxxxxxxxxxxxxxx?key=yyyyyyyyyyyy
```

---

## 🌐 2. GitHub Variables

### Ubicación
```
Tu Repositorio → Settings → Secrets and variables → Actions → Variables
```

### Variables requeridas (4 total)

```
┌─────────────────────────────────────────────┐
│ Repository variables                        │
├─────────────────────────────────────────────┤
│ QA_BACKEND_URL                             │
│ https://tiktask-backend-qa.onrender.com   │
│ [Update] [Remove]                           │
├─────────────────────────────────────────────┤
│ QA_FRONTEND_URL                            │
│ https://tiktask-frontend-qa.onrender.com  │
│ [Update] [Remove]                           │
├─────────────────────────────────────────────┤
│ PROD_BACKEND_URL                           │
│ https://tiktask-backend-prod.onrender.com │
│ [Update] [Remove]                           │
├─────────────────────────────────────────────┤
│ PROD_FRONTEND_URL                          │
│ https://tiktask-frontend-prod.onrender.com│
│ [Update] [Remove]                           │
└─────────────────────────────────────────────┘
```

---

## 🏗️ 3. GitHub Environments

### Ubicación
```
Tu Repositorio → Settings → Environments
```

### Environment: QA

```
┌─────────────────────────────────────────────┐
│ QA                                          │
├─────────────────────────────────────────────┤
│ Deployment branches and tags                │
│ ☑ All branches                              │
│                                             │
│ Environment protection rules                │
│ ☐ Required reviewers                        │
│ ☐ Wait timer                                │
│                                             │
│ Environment secrets (optional)              │
│ (ninguno requerido)                         │
│                                             │
│ Environment variables (optional)            │
│ QA_FRONTEND_URL                             │
│ QA_BACKEND_URL                              │
└─────────────────────────────────────────────┘
```

### Environment: Production

```
┌─────────────────────────────────────────────┐
│ Production                                  │
├─────────────────────────────────────────────┤
│ Deployment branches and tags                │
│ ☑ Selected branches                         │
│   - main                                    │
│                                             │
│ Environment protection rules                │
│ ☑ Required reviewers                        │
│   Add up to 6 reviewers                     │
│   - @tu-usuario                             │
│                                             │
│ ☐ Wait timer                                │
│   0 minutes                                 │
│                                             │
│ Environment secrets (optional)              │
│ (ninguno requerido)                         │
│                                             │
│ Environment variables (optional)            │
│ PROD_FRONTEND_URL                           │
│ PROD_BACKEND_URL                            │
└─────────────────────────────────────────────┘
```

---

## 🎨 4. Render - Crear Servicio Backend QA

### Paso 1: New Web Service

```
┌─────────────────────────────────────────────┐
│ Create a new Web Service                   │
├─────────────────────────────────────────────┤
│ ○ Build and deploy from a Git repository   │
│ ● Deploy an existing image from a registry │
│                                             │
│ [Continue]                                  │
└─────────────────────────────────────────────┘
```

### Paso 2: Configuración básica

```
┌─────────────────────────────────────────────┐
│ Service Details                             │
├─────────────────────────────────────────────┤
│ Name                                        │
│ tiktask-backend-qa                         │
│                                             │
│ Region                                      │
│ [Oregon (US West)] ▼                        │
│                                             │
│ Image URL                                   │
│ ghcr.io/tu-usuario/tiktask-backend:latest  │
│                                             │
│ Instance Type                               │
│ [Free] ▼                                    │
└─────────────────────────────────────────────┘
```

### Paso 3: Environment Variables

```
┌─────────────────────────────────────────────┐
│ Environment                                 │
├─────────────────────────────────────────────┤
│ [Add Environment Variable]                  │
│                                             │
│ Key: NODE_ENV                               │
│ Value: qa                                   │
│                                             │
│ Key: PORT                                   │
│ Value: 3000                                 │
│                                             │
│ Key: DATABASE_PATH                          │
│ Value: /app/data/database.sqlite            │
│                                             │
│ Key: JWT_SECRET                             │
│ [Generate] ← Click aquí                     │
│                                             │
│ Key: RENDER_ENV                             │
│ Value: qa                                   │
└─────────────────────────────────────────────┘
```

### Paso 4: Disk Configuration

```
┌─────────────────────────────────────────────┐
│ Disk                                        │
├─────────────────────────────────────────────┤
│ [Add Disk]                                  │
│                                             │
│ Name: tiktask-backend-qa-data              │
│ Mount Path: /app/data                       │
│ Size: 1 GB                                  │
└─────────────────────────────────────────────┘
```

### Paso 5: Advanced Settings

```
┌─────────────────────────────────────────────┐
│ Advanced                                    │
├─────────────────────────────────────────────┤
│ Health Check Path                           │
│ /api/health                                 │
│                                             │
│ Auto-Deploy                                 │
│ ● Yes (for QA)                              │
│ ○ No                                        │
└─────────────────────────────────────────────┘
```

### Paso 6: Obtener Deploy Hook

Después de crear el servicio:

```
┌─────────────────────────────────────────────┐
│ tiktask-backend-qa                         │
├─────────────────────────────────────────────┤
│ Settings → Deploy Hook                      │
│                                             │
│ https://api.render.com/deploy/srv-xxx...   │
│ [Copy to clipboard]                         │
│                                             │
│ ⚠️ Guarda esto como:                        │
│    RENDER_BACKEND_QA_DEPLOY_HOOK           │
└─────────────────────────────────────────────┘
```

---

## 🎨 5. Render - Crear Servicio Frontend QA

### Configuración básica

```
┌─────────────────────────────────────────────┐
│ Service Details                             │
├─────────────────────────────────────────────┤
│ Name                                        │
│ tiktask-frontend-qa                        │
│                                             │
│ Region                                      │
│ [Oregon (US West)] ▼                        │
│                                             │
│ Image URL                                   │
│ ghcr.io/tu-usuario/tiktask-frontend:latest │
│                                             │
│ Instance Type                               │
│ [Free] ▼                                    │
└─────────────────────────────────────────────┘
```

### Environment Variables

```
┌─────────────────────────────────────────────┐
│ Environment                                 │
├─────────────────────────────────────────────┤
│ Key: BACKEND_URL                            │
│ Value: https://tiktask-backend-qa.onrender.com
│                                             │
│ ⚠️ IMPORTANTE: Usa la URL REAL del backend │
│    que acabas de crear arriba              │
└─────────────────────────────────────────────┘
```

### Advanced Settings

```
┌─────────────────────────────────────────────┐
│ Advanced                                    │
├─────────────────────────────────────────────┤
│ Health Check Path                           │
│ /                                           │
│                                             │
│ Auto-Deploy                                 │
│ ● Yes (for QA)                              │
└─────────────────────────────────────────────┘
```

---

## 🎨 6. Render - Crear Servicio Backend PROD

**Misma configuración que Backend QA, pero:**

```
┌─────────────────────────────────────────────┐
│ Diferencias para PROD                      │
├─────────────────────────────────────────────┤
│ Name: tiktask-backend-prod                 │
│                                             │
│ Instance Type: [Starter] ▼                  │
│                                             │
│ Environment Variables:                      │
│   NODE_ENV=production                       │
│   RENDER_ENV=production                     │
│   JWT_SECRET=[Generate nuevo]               │
│                                             │
│ Disk Name: tiktask-backend-prod-data       │
│                                             │
│ Auto-Deploy: No ●                           │
│   (requiere deploy manual)                  │
└─────────────────────────────────────────────┘
```

---

## 🎨 7. Render - Crear Servicio Frontend PROD

**Misma configuración que Frontend QA, pero:**

```
┌─────────────────────────────────────────────┐
│ Diferencias para PROD                      │
├─────────────────────────────────────────────┤
│ Name: tiktask-frontend-prod                │
│                                             │
│ Instance Type: [Starter] ▼                  │
│                                             │
│ Environment Variables:                      │
│   BACKEND_URL=https://tiktask-backend-prod.onrender.com
│                                             │
│ Auto-Deploy: No ●                           │
└─────────────────────────────────────────────┘
```

---

## 📦 8. GitHub Container Registry - Verificar Imágenes

### Ubicación
```
https://github.com/tu-usuario?tab=packages
```

### Después del primer push exitoso verás:

```
┌─────────────────────────────────────────────┐
│ Packages                                    │
├─────────────────────────────────────────────┤
│ 📦 tiktask-backend                         │
│    Container                                │
│    Updated 5 minutes ago                    │
│    [Package settings]                       │
│                                             │
│ 📦 tiktask-frontend                        │
│    Container                                │
│    Updated 5 minutes ago                    │
│    [Package settings]                       │
└─────────────────────────────────────────────┘
```

### Hacer paquetes públicos (necesario para Render Free)

Click en cada paquete → Package settings:

```
┌─────────────────────────────────────────────┐
│ Danger Zone                                 │
├─────────────────────────────────────────────┤
│ Change package visibility                   │
│                                             │
│ This package is currently Private           │
│                                             │
│ [Change visibility]                         │
│                                             │
│ → Confirm: Make Public                      │
└─────────────────────────────────────────────┘
```

---

## 🚀 9. GitHub Actions - Workflow en ejecución

### Vista del workflow

```
┌─────────────────────────────────────────────┐
│ CI/CD - Build, Push to GHCR & Deploy       │
│ #42 main                                    │
├─────────────────────────────────────────────┤
│ ✅ build-and-test         2m 34s            │
│ ✅ docker-build-push      5m 12s            │
│ ✅ deploy-qa              1m 45s            │
│ ⏸️  deploy-prod           Waiting...        │
│    [Review deployments]                     │
└─────────────────────────────────────────────┘
```

### Al hacer click en "Review deployments"

```
┌─────────────────────────────────────────────┐
│ Review pending deployments                  │
├─────────────────────────────────────────────┤
│ ☑ Production                                │
│   Environment url:                          │
│   https://tiktask-frontend-prod.onrender.com│
│                                             │
│ Comment (optional)                          │
│ ┌─────────────────────────────────────┐    │
│ │ Tested in QA, ready for prod       │    │
│ └─────────────────────────────────────┘    │
│                                             │
│ [Approve and deploy] [Reject]               │
└─────────────────────────────────────────────┘
```

---

## ✅ 10. Verificación Final

### Servicios corriendo en Render Dashboard

```
┌─────────────────────────────────────────────┐
│ Services                                    │
├─────────────────────────────────────────────┤
│ 🟢 tiktask-backend-qa      Free             │
│    https://tiktask-backend-qa.onrender.com  │
│                                             │
│ 🟢 tiktask-frontend-qa     Free             │
│    https://tiktask-frontend-qa.onrender.com │
│                                             │
│ 🟢 tiktask-backend-prod    Starter          │
│    https://tiktask-backend-prod.onrender.com│
│                                             │
│ 🟢 tiktask-frontend-prod   Starter          │
│    https://tiktask-frontend-prod.onrender.com
└─────────────────────────────────────────────┘
```

### Health Checks

Probar en el navegador o con curl:

```bash
# QA Backend
curl https://tiktask-backend-qa.onrender.com/api/health
# Respuesta: {"status":"ok","message":"Server is running"}

# QA Frontend
curl -I https://tiktask-frontend-qa.onrender.com
# Respuesta: HTTP/2 200

# PROD Backend
curl https://tiktask-backend-prod.onrender.com/api/health
# Respuesta: {"status":"ok","message":"Server is running"}

# PROD Frontend
curl -I https://tiktask-frontend-prod.onrender.com
# Respuesta: HTTP/2 200
```

---

## 🎯 Checklist Final de Configuración

Marca cada item cuando esté completado:

### GitHub
- [ ] 4 Secrets configurados
- [ ] 4 Variables configuradas
- [ ] Environment "QA" creado (sin required reviewers)
- [ ] Environment "Production" creado (con required reviewers)
- [ ] 2 Packages visibles en GitHub (backend + frontend)
- [ ] Packages configurados como públicos

### Render
- [ ] Servicio backend-qa creado y corriendo
- [ ] Servicio frontend-qa creado y corriendo
- [ ] Servicio backend-prod creado y corriendo
- [ ] Servicio frontend-prod creado y corriendo
- [ ] Deploy hooks de los 4 servicios copiados a GitHub Secrets
- [ ] URLs de los 4 servicios agregadas a GitHub Variables

### Verificación
- [ ] Push a main triggerea el workflow
- [ ] Build & test pasa correctamente
- [ ] Imágenes se pushean a GHCR
- [ ] Deploy a QA se ejecuta automáticamente
- [ ] Deploy a PROD espera aprobación
- [ ] Backend QA responde a /api/health
- [ ] Frontend QA carga correctamente
- [ ] Después de aprobación, PROD se deploya
- [ ] Backend PROD responde a /api/health
- [ ] Frontend PROD carga correctamente

---

## 📞 Troubleshooting Visual

### ❌ Error: "Failed to pull image"

```
Render logs:
┌─────────────────────────────────────────────┐
│ Failed to pull image                        │
│ ghcr.io/usuario/tiktask-backend:latest      │
│ unauthorized: authentication required       │
└─────────────────────────────────────────────┘

Solución:
→ Hacer el paquete público en GitHub
```

### ❌ Error: "Health check failed"

```
Render dashboard:
┌─────────────────────────────────────────────┐
│ 🔴 tiktask-backend-qa                       │
│    Health check failing at /api/health      │
│    (503 Service Unavailable)                │
└─────────────────────────────────────────────┘

Solución:
→ Esperar 1-2 minutos (servicio iniciando)
→ Verificar logs del servicio
→ Verificar que DATABASE_PATH esté configurado
```

### ❌ Error: "Frontend can't connect to backend"

```
Browser console:
┌─────────────────────────────────────────────┐
│ Failed to load resource:                    │
│ https://tiktask-frontend-qa.onrender.com/api│
│ 502 Bad Gateway                             │
└─────────────────────────────────────────────┘

Solución:
→ Verificar variable BACKEND_URL en frontend
→ Debe ser: https://tiktask-backend-qa.onrender.com
→ SIN /api al final
```

---

**¡Con esta guía visual deberías poder configurar todo correctamente!** 🎉
