FROM nginx:alpine

LABEL maintainer="Manaiakalani"
LABEL description="GitHub ASCII Cube — 3D ASCII art with Three.js + GLSL shader"

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy static files
COPY index.html /usr/share/nginx/html/
COPY about.html /usr/share/nginx/html/

# Custom nginx config for SPA-friendly serving + caching
RUN echo 'server { \
    listen 80; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
    \
    location ~* \.(html)$ { \
        add_header Cache-Control "no-cache, must-revalidate"; \
    } \
    \
    gzip on; \
    gzip_types text/html text/css application/javascript; \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
