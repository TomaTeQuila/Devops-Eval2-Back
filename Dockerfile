# ── Stage 1: build ──────────────────────────────────────────────────────────
FROM node:20.19.0-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# ── Stage 2: production ──────────────────────────────────────────────────────
FROM node:20.19.0-alpine

WORKDIR /app

# Usuario no-root por seguridad
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

ENV NODE_ENV=production

# Copiar dependencias y código fuente
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 3000

ENV NODE_ENV=production

CMD ["node", "server.js"]
