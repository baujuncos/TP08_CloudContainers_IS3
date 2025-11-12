#!/bin/sh

# Default to QA if BACKEND_URL is not set
BACKEND_URL=${BACKEND_URL:-https://tiktask-backend-qa.onrender.com}

# Replace variables in nginx config
envsubst '${BACKEND_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'
