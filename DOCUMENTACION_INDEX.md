# 📚 Índice de Documentación TP8

Bienvenido a la documentación del TP8. Aquí encontrarás todo lo necesario para configurar y entender el pipeline CI/CD implementado.

---

## 🚀 ¿Por dónde empezar?

### Si quieres CONFIGURAR el pipeline:
👉 **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - EMPIEZA AQUÍ

### Si quieres ENTENDER las decisiones técnicas:
👉 **[DECISIONES_ARQUITECTONICAS.md](./DECISIONES_ARQUITECTONICAS.md)**

### Si prefieres guías VISUALES paso a paso:
👉 **[GUIA_VISUAL.md](./GUIA_VISUAL.md)**

### Si quieres información GENERAL del proyecto:
👉 **[README.md](./README.md)**

---

## 📖 Descripción de cada documento

### 1. SETUP_GUIDE.md
**Propósito:** Guía práctica de configuración paso a paso

**Contenido:**
- Arquitectura implementada (diagrama ASCII)
- Configuración de GitHub Container Registry (GHCR)
- Configuración de Secrets en GitHub (4 deploy hooks)
- Configuración de Variables en GitHub (4 URLs)
- Creación de 4 servicios en Render (paso a paso)
- Configuración de GitHub Environments (approval gates)
- Cómo probar el pipeline
- Troubleshooting común

**Cuándo usar:**
- Cuando necesitas configurar el pipeline desde cero
- Cuando algo no funciona y necesitas verificar configuración
- Como referencia durante la configuración

**Tiempo estimado:** 30-45 minutos

---

### 2. DECISIONES_ARQUITECTONICAS.md
**Propósito:** Justificación técnica de todas las decisiones de arquitectura

**Contenido:**
- Justificación del stack tecnológico (Node.js, Express, SQLite)
- Por qué GitHub Container Registry vs otras opciones
- Por qué Render.com vs AWS/Azure/GCP
- Por qué GitHub Actions vs otras herramientas CI/CD
- Decisión de usar mismo servicio para QA y PROD
- Por qué separar frontend y backend en contenedores diferentes
- Por qué reutilizar imágenes entre ambientes
- Estrategia de versionado y tagging
- Gestión de secretos y variables de entorno
- Configuración de recursos para QA vs PROD
- Pipeline CI/CD y flujo de deployment
- Referencias técnicas y mejores prácticas

**Cuándo usar:**
- Para el informe del TP8
- Para entender el "por qué" de cada decisión
- Para defender elecciones técnicas en presentaciones
- Para aprender sobre arquitectura de contenedores

**Ideal para:** Documentación de entrega del TP

---

### 3. GUIA_VISUAL.md
**Propósito:** Ejemplos visuales de cómo se ve cada configuración

**Contenido:**
- Capturas de texto (ASCII art) de GitHub Secrets
- Ejemplos visuales de GitHub Variables
- Cómo se ven los GitHub Environments configurados
- Paso a paso visual para crear servicios en Render
- Cómo verificar que las imágenes están en GHCR
- Cómo se ve el workflow en ejecución
- Cómo aprobar deployments
- Checklist de verificación visual
- Troubleshooting con ejemplos visuales

**Cuándo usar:**
- Si prefieres ejemplos visuales vs texto
- Para verificar que tu configuración se ve correcta
- Como complemento a SETUP_GUIDE.md
- Para capturas de pantalla del informe

**Ideal para:** Usuarios visuales, capturas del TP

---

### 4. README.md
**Propósito:** Punto de entrada principal del proyecto

**Contenido:**
- Descripción general del proyecto TikTask
- Quick start con Docker
- Arquitectura general del TP8
- Componentes y tecnologías usadas
- Características de la aplicación
- Testing y desarrollo local
- Enlaces a todas las guías

**Cuándo usar:**
- Primera vez que llegas al repositorio
- Para entender qué es TikTask
- Para ejecutar el proyecto localmente
- Para navegar a otras guías

---

### 5. GUIA_TP8.md (existente)
**Propósito:** Guía de referencia original con información adicional

**Contenido:**
- Información complementaria del TP8
- Contexto histórico del proyecto
- Detalles técnicos adicionales

**Cuándo usar:**
- Como referencia adicional
- Para contexto histórico

---

### 6. TP8_consignas.MD (existente)
**Propósito:** Consignas oficiales del trabajo práctico

**Contenido:**
- Requisitos del TP8
- Qué se debe entregar
- Criterios de evaluación
- Ejemplos de arquitecturas válidas

**Cuándo usar:**
- Para verificar que cumples todos los requisitos
- Como checklist de entregables
- Para entender qué se espera del TP

---

## 🎯 Flujo recomendado de lectura

### Para implementar el TP8 (orden recomendado):

```
1. README.md (5 min)
   ↓ Entender qué es el proyecto
   
2. TP8_consignas.MD (10 min)
   ↓ Entender qué se pide
   
3. SETUP_GUIDE.md (30-45 min)
   ↓ Configurar todo paso a paso
   
4. GUIA_VISUAL.md (referencia paralela)
   ↓ Verificar que configuraste bien
   
5. Probar el pipeline
   ↓ Push a main, verificar que funciona
   
6. DECISIONES_ARQUITECTONICAS.md (20 min)
   ↓ Para el informe escrito
```

### Para el informe del TP8:

```
1. DECISIONES_ARQUITECTONICAS.md
   ↓ Usar como base para sección de justificaciones
   
2. GUIA_VISUAL.md
   ↓ Tomar capturas para evidencias
   
3. SETUP_GUIDE.md
   ↓ Detalles de implementación
```

---

## 📊 Resumen Rápido

### ¿Qué se implementó?

- ✅ 2 imágenes Docker (frontend + backend)
- ✅ 4 servicios en Render (2 por ambiente)
- ✅ Pipeline CI/CD completo con GitHub Actions
- ✅ Deploy automático a QA
- ✅ Deploy manual a PROD (con approval)
- ✅ Gestión de secretos y variables
- ✅ Versionado de imágenes en GHCR

### ¿Qué necesita el usuario configurar?

- 4 GitHub Secrets (deploy hooks)
- 4 GitHub Variables (URLs)
- 2 GitHub Environments (QA + Production)
- 4 servicios en Render (frontend-qa, backend-qa, frontend-prod, backend-prod)

### ¿Cuánto cuesta?

- GitHub Actions: **GRATIS**
- GitHub Container Registry: **GRATIS**
- Render QA (2 servicios free): **GRATIS**
- Render PROD (2 servicios starter): **$14/mes** (opcional: puede usarse free)

---

## 🆘 ¿Necesitas ayuda?

1. **Configuración:** Ver SETUP_GUIDE.md sección Troubleshooting
2. **Errores:** Ver GUIA_VISUAL.md sección Troubleshooting Visual
3. **Conceptos:** Ver DECISIONES_ARQUITECTONICAS.md
4. **Issues:** [GitHub Issues](https://github.com/baujuncos/TP08_CloudContainers_IS3/issues)

---

## ✅ Checklist de Entregables TP8

Para verificar que cumples con todos los requisitos:

### Código y Configuración
- [x] Dockerfiles optimizados (frontend + backend)
- [x] docker-compose.yml para desarrollo local
- [x] render.yaml con configuración de 4 servicios
- [x] .github/workflows/cicd-pipeline.yml completo
- [x] nginx.conf configurado para proxy al backend

### Documentación Técnica
- [x] README.md actualizado
- [x] SETUP_GUIDE.md con instrucciones paso a paso
- [x] DECISIONES_ARQUITECTONICAS.md con justificaciones
- [x] GUIA_VISUAL.md con ejemplos visuales

### Implementación Cloud
- [ ] Container Registry funcionando (GHCR)
- [ ] Ambiente QA deployado y accesible
- [ ] Ambiente PROD deployado y accesible
- [ ] Pipeline CI/CD ejecutándose correctamente

### Evidencias (para informe)
- [ ] Capturas de GHCR con imágenes y tags
- [ ] Capturas de servicios en Render
- [ ] Capturas de GitHub Actions workflow
- [ ] Capturas de approval gate funcionando
- [ ] URLs funcionales de QA y PROD

---

**¡Todo listo para implementar tu TP8!** 🚀

Empieza por [SETUP_GUIDE.md](./SETUP_GUIDE.md) y sigue los pasos.
