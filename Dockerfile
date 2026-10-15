# syntax=docker/dockerfile:1.7
# Production image: small, non-root, no build tooling, with a health check.
# Pin by digest in real production (Dependabot can keep it updated).
ARG NODE_VERSION=24
FROM node:${NODE_VERSION}-alpine

ENV NODE_ENV=production \
    PORT=3000

# tini = proper PID 1 (signal forwarding + zombie reaping)
RUN apk add --no-cache tini

WORKDIR /app
COPY --chown=node:node app/package.json ./
COPY --chown=node:node app/src ./src

USER node
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- "http://127.0.0.1:${PORT}/health" || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "src/server.js"]
