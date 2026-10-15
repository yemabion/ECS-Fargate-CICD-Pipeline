'use strict';

const http = require('node:http');

const MESSAGE = 'Hello from CI/CD Pipeline!';

const BASE_HEADERS = {
  'X-Content-Type-Options': 'nosniff',
  'Cache-Control': 'no-store',
};

function send(res, status, body, contentType = 'text/plain; charset=utf-8', extra = {}) {
  res.writeHead(status, { ...BASE_HEADERS, 'Content-Type': contentType, ...extra });
  res.end(body);
}

/**
 * Builds the HTTP server. Kept separate from server.js so tests can
 * start it on an ephemeral port without side effects.
 */
function createApp({ logger = () => {} } = {}) {
  return http.createServer((req, res) => {
    const started = process.hrtime.bigint();
    const path = (req.url || '/').split('?')[0];

    res.on('finish', () => {
      // Skip load-balancer health checks to keep logs useful.
      if (path === '/health') return;
      logger({
        method: req.method,
        path,
        status: res.statusCode,
        ms: Number(process.hrtime.bigint() - started) / 1e6,
      });
    });

    if (req.method !== 'GET' && req.method !== 'HEAD') {
      return send(res, 405, 'Method Not Allowed', undefined, { Allow: 'GET, HEAD' });
    }

    switch (path) {
      case '/':
        return send(res, 200, MESSAGE);
      case '/health':
        return send(res, 200, JSON.stringify({ status: 'ok' }), 'application/json');
      default:
        return send(res, 404, 'Not Found');
    }
  });
}

module.exports = { createApp, MESSAGE };
