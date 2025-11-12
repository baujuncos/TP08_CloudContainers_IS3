FROM nginx:alpine

# Instalar gettext para envsubst (sustitución de variables)
RUN apk add --no-cache gettext

# Copiar archivos del frontend
COPY index.html /usr/share/nginx/html/
COPY app.js /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/

# Copiar template de configuración de nginx
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Copiar script de inicio
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Exponer puerto 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]