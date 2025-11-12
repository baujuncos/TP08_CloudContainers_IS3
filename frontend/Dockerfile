# Frontend Dockerfile - Serve static files with nginx
FROM nginx:alpine

# Install envsubst for environment variable substitution
RUN apk add --no-cache gettext

# Copy static files to nginx html directory
COPY index.html styles.css app.js /usr/share/nginx/html/

# Copy nginx configuration template
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Set default backend URL (can be overridden with environment variable)
ENV BACKEND_URL=http://backend:3000

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Use entrypoint script to substitute environment variables
# nginx:alpine image includes docker-entrypoint.sh that processes templates
CMD ["nginx", "-g", "daemon off;"]
