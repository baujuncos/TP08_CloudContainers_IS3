#!/bin/sh

# Default to QA if BACKEND_URL is not set
BACKEND_URL=${BACKEND_URL:-https://tiktask-backend-qa.onrender.com}

# Extract host from URL
BACKEND_HOST=$(echo $BACKEND_URL | sed -e 's|https\?://||' -e 's|/.*||')

# Replace variables in nginx config
envsubst '${BACKEND_URL} ${BACKEND_HOST}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'
