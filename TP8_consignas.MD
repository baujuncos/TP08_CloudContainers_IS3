## 🎯 Enfoque del Trabajo Práctico

Este trabajo práctico es **cloud-agnostic** y **technology-agnostic**.

**Objetivo principal**: Demostrar que comprendés:
- Los conceptos de contenedores y su orquestación
- Servicios de contenedores en la nube (cualquier provider)
- CI/CD con contenedores
- Cómo tomar decisiones arquitectónicas justificadas

**Libertad total de elección**:
- ✅ Podés usar **Azure, AWS, Google Cloud, o servicios gratuitos** (Render, Fly.io, Railway, etc.)
- ✅ Podés usar **cualquier stack tecnológico** (Node.js, Python, Java, Go, .NET, Ruby, etc.)
- ✅ Podés usar **cualquier herramienta de CI/CD** (Azure DevOps, GitHub Actions, GitLab CI, CircleCI, etc.)

---

## Contexto del Trabajo Práctico

Deberás implementar una solución completa de contenedores en la nube para una aplicación de tu elección. La aplicación **debe ser diferente** a la de los ejemplos de la guía

---

## 💰 Recomendación sobre Costos

**NO es necesario gastar dinero para este TP**. Existen alternativas 100% gratuitas:

### Stacks completamente GRATUITOS recomendados:

**Opción 1: GitHub Stack** (100% gratis)
- Container Registry: GitHub Container Registry
- Hosting: Render.com o Fly.io
- CI/CD: GitHub Actions
- Base de datos: Railway o Supabase

**Opción 2: GitLab Stack** (100% gratis)
- Container Registry: GitLab Container Registry
- Hosting: Google Cloud Run (free tier)
- CI/CD: GitLab CI/CD
- Base de datos: PlanetScale o MongoDB Atlas

**Opción 3: Mixed Stack** (100% gratis)
- Container Registry: Docker Hub
- Hosting: Railway.app
- CI/CD: CircleCI
- Base de datos: CockroachDB Serverless

---

## Consignas del Trabajo Práctico

**IMPORTANTE**:
- NO usar la aplicación de la guía
- Usar una aplicación diferente con el stack tecnológico de tu elección, preferentemente usar la que venias usando en los TPs anteriores asi ya te queda casi listo el TP integrador.
- Podés usar servicios de cualquier proveedor cloud (no solo Azure)

### 1. Configuración de Container Registry

**Concepto**: Implementar un registro privado/público de imágenes Docker

**Requisitos**:
- Crear y configurar un Container Registry (ACR, Docker Hub, GitHub CR, GitLab CR, etc.)
- Configurar autenticación y permisos de acceso
- Documentar el proceso de creación y configuración
- Integrar el registry en tu pipeline de CI/CD
- **Justificar la elección** del servicio de registry (¿Por qué elegiste ese y no otro?)

**Ejemplos de servicios**:
- Azure Container Registry (ACR)
- Docker Hub
- GitHub Container Registry (ghcr.io)
- GitLab Container Registry
- Google Container Registry (GCR)
- Amazon Elastic Container Registry (ECR)

### 2. Deploy en Ambiente QA 

**Concepto**: Desplegar tu aplicación en un ambiente de QA/Testing con configuración apropiada

**Requisitos**:
- Elegir un servicio de contenedores en la nube (cualquiera)
- Desplegar tu aplicación (backend y frontend) en QA
- Configurar variables de entorno y secretos de forma segura
- Configurar networking y acceso público (URLs)
- Configurar recursos apropiados para testing (CPU, memoria)
- **Justificar** por qué elegiste ese servicio y esa configuración para QA

**Ejemplos de servicios**:
- Azure: Container Instances, App Services, Container Apps
- AWS: App Runner, Elastic Beanstalk, ECS Fargate
- Google Cloud: Cloud Run, App Engine
- Gratuitos: Render.com, Fly.io, Railway.app, Heroku

### 3. Deploy en Ambiente PROD

**Concepto**: Desplegar tu aplicación en ambiente productivo con configuración apropiada

**Requisitos**:
- Usar el **MISMO servicio** que en QA pero con configuración diferente
- O usar un **servicio DIFERENTE** (justificar el cambio)
- Desplegar tu aplicación en PROD
- Configurar escalabilidad y alta disponibilidad
- Configurar recursos apropiados para producción (CPU, memoria, réplicas)
- Implementar continuous deployment desde tu registry
- **Documentar diferencias** de configuración entre QA y PROD
- **Justificar decisiones**: ¿Por qué esta configuración para PROD?

**Si usás el mismo servicio**:
- Mostrar cómo la configuración difiere entre ambientes
- Explicar estrategia de segregación de ambientes
- Documentar diferencias en recursos, escalabilidad, monitoreo

### 4. Pipeline CI/CD Completo

**Concepto**: Automatizar todo el proceso de build, test y deploy

**Requisitos**:
- Desarrollar pipeline que incluya:
  - Build y test de aplicación
  - Construcción de imágenes Docker optimizadas
  - Push de imágenes a tu registry con versionado (tags)
  - Deploy automático a ambientes QA y PROD
  - Quality gates y aprobaciones manuales entre ambientes


**Ejemplos de herramientas**:
- Azure DevOps Pipelines
- GitHub Actions
- GitLab CI/CD
- CircleCI
- Jenkins
- Travis CI

---

## Arquitectura Mínima Requerida

Tu solución debe incluir los siguientes **conceptos** (podés usar los servicios que quieras):

1. **Container Registry**: Repositorio de imágenes (público o privado)
2. **Ambiente QA**: Deploy de contenedores para testing
3. **Ambiente PROD**: Deploy de contenedores para producción
4. **Pipeline CI/CD**: Automatización completa con la herramienta que elijas
5. **Gestión de Secretos**: Variables secretas correctamente configuradas
6. **Versionado**: Tags en imágenes Docker (no usar solo "latest")
7. **Segregación de Ambientes**: QA y PROD diferenciados (mismo servicio con diferente config, o servicios diferentes)
8. **Documentación**: Justificación de todas las decisiones técnicas

### Ejemplos de Arquitecturas Válidas:

**Ejemplo 1: Mismo servicio, diferente configuración (GitHub + Render - 100% gratis)**
```
GitHub Repo
  → GitHub Actions (CI/CD)
    → Build + Test
    → Docker Build
    → Push to GitHub Container Registry (ghcr.io)
    → Deploy to Render.com QA (1 instancia, 512MB RAM)
    → Approval Gate
    → Deploy to Render.com PROD (2 instancias, 1GB RAM, auto-scaling)
```

**Ejemplo 2: Servicios diferentes (GitLab Stack - 100% gratis)**
```
GitLab Repo
  → GitLab CI/CD
    → Build + Test
    → Docker Build
    → Push to GitLab Container Registry
    → Deploy to Google Cloud Run (QA - free tier, minimal config)
    → Approval Gate
    → Deploy to Render.com (PROD - más control, mejor performance)
```

**Ejemplo 3: Mismo servicio Azure (con créditos estudiantiles)**
```
Azure DevOps Repo
  → Azure Pipelines
    → Build + Test
    → Docker Build
    → Push to Azure Container Registry
    → Deploy to Azure Container Instances QA (1 vCPU, 1.5GB)
    → Approval Gate
    → Deploy to Azure Container Instances PROD (2 vCPU, 4GB, múltiples instancias)
```

**Ejemplo 4: Servicios diferentes Azure (con créditos estudiantiles)**
```
Azure DevOps Repo
  → Azure Pipelines
    → Build + Test
    → Docker Build
    → Push to Azure Container Registry
    → Deploy to Azure Container Instances (QA - rápido, económico para testing)
    → Approval Gate
    → Deploy to Azure App Services (PROD - auto-scaling, monitoring avanzado)
```

**Ejemplo 5: Mixed Stack (100% gratis)**
```
GitHub Repo
  → GitHub Actions
    → Build + Test
    → Docker Build
    → Push to Docker Hub
    → Deploy to Railway.app QA (recursos limitados)
    → Approval Gate
    → Deploy to Railway.app PROD (más recursos, múltiples regiones)
```

---

## Entregables

**⚠️ Recordatorio**: NO usar la aplicación de la guía. Usar tu propia aplicación con el stack que elijas.

### 1. Repositorio actualizado con:
- Código fuente de tu aplicación
- Dockerfiles optimizados para backend y frontend
- Archivos de configuración de CI/CD (YAML, JSON, o el formato que uses)
- Documentación técnica (README.md)

### 2. Documento técnico (PDF o Markdown) que incluya:

#### Sección 1: Decisiones Arquitectónicas y Tecnológicas
- **Stack tecnológico elegido** y justificación (lenguajes, frameworks, librerías)
- **Servicios cloud elegidos** y justificación:
  - ¿Por qué elegiste ese Container Registry?
  - ¿Por qué elegiste ese/esos servicio/s de hosting?
  - ¿Por qué elegiste esa herramienta de CI/CD?
- **Decisión QA vs PROD**:
  - Si usaste el mismo servicio: ¿Por qué? ¿Cómo diferenciás los ambientes?
  - Si usaste servicios diferentes: ¿Por qué? ¿Qué ventajas te da cada uno?
- **Configuración de recursos** (CPU, memoria, instancias, límites) para cada ambiente

#### Sección 2: Implementación

**Container Registry**:
- Evidencia del registry funcionando (capturas con imágenes y tags)
- Configuración de autenticación y permisos

**Ambiente QA**:
- Evidencia de deploy funcionando (capturas, URLs, configuración)
- Variables de entorno y secretos configurados
- Configuración de recursos (CPU, memoria, instancias)

**Ambiente PROD**:
- Evidencia de deploy funcionando (capturas, URLs, configuración)
- Configuración de recursos y escalabilidad
- Continuous deployment configurado
- Diferencias clave con QA (configuración, recursos, seguridad)

**Pipeline CI/CD**:
- Pipeline ejecutándose exitosamente con todas las etapas
- Capturas de cada stage (build, test, push, deploy QA, approval, deploy PROD)

#### Sección 3: Análisis Comparativo

**Tabla comparativa QA vs PROD**:
| Aspecto | QA | PROD | Justificación |
|---------|-----|------|---------------|
| Servicio usado | ... | ... | ... |
| CPU/Memoria | ... | ... | ... |
| Número de instancias | ... | ... | ... |
| Escalabilidad | ... | ... | ... |
| Costos | ... | ... | ... |
| Monitoreo/Logs | ... | ... | ... |

**Si usaste el mismo servicio**:
- Ventajas de usar el mismo servicio para ambos ambientes
- Desventajas o limitaciones encontradas
- Cómo diferenciaste QA de PROD en la práctica

**Si usaste servicios diferentes**:
- Por qué cada servicio es apropiado para cada ambiente
- Trade-offs de la decisión
- Complejidad adicional de manejar dos servicios diferentes

**Análisis de alternativas**:
- Qué otros servicios consideraste
- Por qué no los elegiste
- En qué casos serían mejores opciones

**Análisis de costos** (si aplicás):
- Costos estimados QA vs PROD
- Comparación con alternativas
- Estrategias de optimización

**Escalabilidad a futuro**:
- ¿Cuándo migrarías a Kubernetes?
- ¿Qué cambiarías si la aplicación crece 10x?

#### Sección 4: Reflexión Personal
- **Desafíos encontrados** y cómo los resolviste
- **Qué mejorarías** en una implementación productiva real
- **Aprendizajes clave** del trabajo práctico
- **Comparación** con otros stacks que evaluaste pero no elegiste

### 3. Demo funcional donde puedas mostrar:
- Aplicación funcionando en ambiente QA (con URL funcionando)
- Aplicación funcionando en ambiente PROD (con URL funcionando)
- Diferencias visibles entre QA y PROD (configuración, recursos, etc.)
- Pipeline completo ejecutándose
- Proceso de deployment de cambios (hacer un cambio y mostrar el deploy automático)
- Approval gate entre QA y PROD funcionando
- Rollback en caso de error (opcional pero recomendado)

---

## Criterios de Evaluación

- **Implementación técnica (15%)**: Correcta configuración de todos los servicios cloud elegidos
- **Arquitectura y diseño (15%)**: Decisiones justificadas y apropiadas para el caso de uso
- **Pipeline CI/CD (10%)**: Automatización completa y buenas prácticas
- **Documentación (20%)**: Claridad, completitud y profesionalismo
- **Defensa oral (40%)**: Capacidad de explicar y justificar todas las decisiones tomadas

---

## Preguntas que deberás poder responder en la defensa

### Sobre Decisiones Arquitectónicas:

1. **¿Por qué elegiste ese stack tecnológico específico?** (lenguajes, frameworks)
2. **¿Por qué elegiste esos servicios cloud específicos?** ¿Evaluaste alternativas?
3. **¿Por qué usaste el mismo servicio (o servicios diferentes) para QA y PROD?** ¿Cuáles son las ventajas y desventajas de tu decisión?
4. **¿Cómo diferenciaste QA de PROD?** (recursos, configuración, seguridad)
5. **Si tuvieras presupuesto ilimitado, ¿cambiarías algo?** ¿Y si tuvieras presupuesto cero?
6. **¿Cuándo usarías Kubernetes en lugar de tus servicios elegidos?** Dame ejemplos concretos.

### Sobre Implementación Técnica:

7. **¿Cómo manejás los secretos en tu pipeline?** ¿Por qué de esa forma? ¿Qué alternativas consideraste?
8. **¿Qué estrategia de versionado usás para tus imágenes Docker?** ¿Por qué? ¿Qué pasa con "latest"?
9. **¿Cómo optimizaste tus Dockerfiles?** ¿Multi-stage builds? ¿Capas? ¿Tamaño de imagen?
10. **¿Qué configuración de recursos elegiste para QA y PROD?** ¿Por qué son diferentes (o iguales)?
11. **¿Cómo implementarías un rollback si un deploy falla en producción?** Explicá el proceso paso a paso.

### Sobre CI/CD y DevOps:

12. **¿Por qué elegiste esa herramienta de CI/CD?** ¿Qué alternativas evaluaste?
13. **¿Cómo tu pipeline diferencia entre deploy a QA y PROD?** ¿Variables? ¿Secrets diferentes?
14. **¿Cómo manejarías más entornos (dev/staging)?** ¿Qué cambiarías en tu pipeline?
15. **¿Qué quality gates implementaste?** ¿Por qué esos y no otros?
16. **¿Cómo asegurás que no se deployee código malo a producción?** Hablame de tus estrategias.

### Sobre Seguridad y Mejores Prácticas:

18. **¿Qué consideraciones de seguridad tuviste en cuenta?** En contenedores, en secrets, en networking.
19. **¿Las configuraciones de seguridad son diferentes en QA vs PROD?** ¿Por qué?
20. **¿Cómo manejás las vulnerabilidades en las imágenes base?** ¿Escaneás tus imágenes?
21. **¿Qué logs y monitoreo implementaste?** ¿Cómo debuggearías un problema en producción?
22. **¿Cómo manejás las bases de datos en contenedores?** ¿Persistencia? ¿Backups?
23. **¿Qué harías diferente en una implementación productiva real con usuarios reales?**

### Bonus (muestra comprensión avanzada):

24. **¿Cómo implementarías auto-scaling en tu arquitectura?** ¿Diferente entre QA y PROD?
25. **¿Cómo manejarías disaster recovery?**
26. **¿Qué métricas importantes monitorearías en producción?**
27. **¿Cómo optimizarías los costos de tu solución?**
28. **Si tuvieras que agregar un ambiente de staging, ¿cómo lo harías?**
29. **¿Qué aprendiste sobre contenedores que no sabías antes de este TP?**

---

## Recursos de Ayuda

### Documentación de Contenedores:
- **Docker**: https://docs.docker.com/
- **Docker best practices**: https://docs.docker.com/develop/dev-best-practices/
- **Dockerfile reference**: https://docs.docker.com/engine/reference/builder/
- **Docker Compose**: https://docs.docker.com/compose/

### Documentación Cloud Providers:

**Azure**:
- Documentación oficial: https://docs.microsoft.com/azure/
- Azure CLI reference: https://docs.microsoft.com/cli/azure/
- Azure DevOps pipelines: https://docs.microsoft.com/azure/devops/pipelines/
- Azure Container Instances: https://docs.microsoft.com/azure/container-instances/
- Azure App Services: https://docs.microsoft.com/azure/app-service/

**AWS**:
- AWS documentation: https://docs.aws.amazon.com/
- Amazon ECR: https://docs.aws.amazon.com/ecr/
- AWS App Runner: https://docs.aws.amazon.com/apprunner/
- AWS Elastic Beanstalk: https://docs.aws.amazon.com/elasticbeanstalk/

**Google Cloud**:
- GCP documentation: https://cloud.google.com/docs
- Google Container Registry: https://cloud.google.com/container-registry/docs
- Google Cloud Run: https://cloud.google.com/run/docs
- Google App Engine: https://cloud.google.com/appengine/docs

### Servicios Gratuitos:

**Container Registries**:
- Docker Hub: https://docs.docker.com/docker-hub/
- GitHub Container Registry: https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry
- GitLab Container Registry: https://docs.gitlab.com/ee/user/packages/container_registry/

**Hosting Gratuito**:
- Render: https://render.com/docs
- Fly.io: https://fly.io/docs/
- Railway: https://docs.railway.app/
- Heroku: https://devcenter.heroku.com/

**CI/CD**:
- GitHub Actions: https://docs.github.com/actions
- GitLab CI/CD: https://docs.gitlab.com/ee/ci/
- CircleCI: https://circleci.com/docs/

### Tutoriales y Guías:
- Docker Getting Started: https://docs.docker.com/get-started/
- Kubernetes Basics: https://kubernetes.io/docs/tutorials/kubernetes-basics/
- CI/CD with Docker: https://docs.docker.com/ci-cd/
- Container Security Best Practices: https://snyk.io/learn/container-security/

### Herramientas útiles:
- **Docker Desktop**: Para desarrollo local
- **k3s/minikube**: Para Kubernetes local
- **Dive**: Para analizar capas de imágenes Docker
- **Trivy**: Para escanear vulnerabilidades en imágenes
- **Hadolint**: Linter para Dockerfiles

---

**¡Éxitos con el trabajo práctico!**

Recordá: Lo más importante no es qué servicios usás, sino que entiendas **por qué** los elegiste y **cómo** funcionan.