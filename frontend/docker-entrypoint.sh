#!/bin/sh
set -e

# Valor por defecto para desarrollo local
export BACKEND_URL="${BACKEND_URL:-http://localhost:3000}"

echo "🚀 Configurando nginx..."
echo "📡 Backend URL: ${BACKEND_URL}"

# Reemplazar variables en el template de nginx
envsubst '${BACKEND_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

echo "✅ Nginx configurado correctamente"

# Ejecutar el comando pasado al contenedor (nginx)
exec "$@"