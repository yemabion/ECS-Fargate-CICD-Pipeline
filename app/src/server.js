'use strict';

const { createApp } = require('./app');

const PORT = Number.parseInt(process.env.PORT ?? '3000', 10);
const HOST = process.env.HOST ?? '0.0.0.0';
const SHUTDOWN_TIMEOUT_MS = 10_000;

function log(level, msg, extra = {}) {
  console.log(JSON.stringify({ ts: new Date().toISOString(), level, msg, ...extra }));
}

const server = createApp({ logger: (entry) => log('info', 'request', entry) });

server.listen(PORT, HOST, () => log('info', 'server_started', { host: HOST, port: PORT }));

// Graceful shutdown: ECS sends SIGTERM and waits (stopTimeout) before SIGKILL.
function shutdown(signal) {
  log('info', 'shutdown_initiated', { signal });
  const timer = setTimeout(() => {
    log('error', 'shutdown_timeout');
    process.exit(1);
  }, SHUTDOWN_TIMEOUT_MS);
  timer.unref();

  server.close((err) => {
    if (err) {
      log('error', 'shutdown_error', { error: err.message });
      process.exit(1);
    }
    log('info', 'shutdown_complete');
    process.exit(0);
  });
  server.closeIdleConnections();
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
