# ── Stage 1: build ──────────────────────────────────────────────────────────
FROM nginx:alpine AS builder

LABEL maintainer="ritikagarg60814@gmail.com"
LABEL description="Ritika Garg — DevOps Resume"

# Copy resume files
COPY index.html /usr/share/nginx/html/index.html
COPY tracker.html /usr/share/nginx/html/tracker.html

# Custom nginx config for SPA
RUN echo 'server { \
  listen 80; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { try_files $uri $uri/ /index.html; } \
  location /health { return 200 "OK"; } \
}' > /etc/nginx/conf.d/default.conf

# ── Stage 2: final ───────────────────────────────────────────────────────────
FROM nginx:alpine
COPY --from=builder /usr/share/nginx/html /usr/share/nginx/html
COPY --from=builder /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/health || exit 1
