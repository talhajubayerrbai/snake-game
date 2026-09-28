'use strict';
const http = require('http');
const assert = require('assert');

// Set port BEFORE requiring server.js so it binds to a non-privileged port
const PORT = 18080;
process.env.PORT = String(PORT);

// Now require server (it will listen on PORT=18080)
require('./server');

function get(urlPath) {
  return new Promise((resolve, reject) => {
    const req = http.get(`http://127.0.0.1:${PORT}${urlPath}`, (res) => {
      let body = '';
      res.on('data', (d) => { body += d; });
      res.on('end', () => resolve({ status: res.statusCode, body }));
    });
    req.on('error', reject);
    req.setTimeout(3000, () => { req.destroy(); reject(new Error('timeout')); });
  });
}

async function run() {
  // Give server a moment to bind
  await new Promise(r => setTimeout(r, 200));

  const health = await get('/health');
  assert.strictEqual(health.status, 200, `/health returned ${health.status}`);
  const parsed = JSON.parse(health.body);
  assert.strictEqual(parsed.status, 'ok', 'health body.status should be ok');
  console.log('PASS /health -> 200');

  const notFound = await get('/nonsense');
  assert.strictEqual(notFound.status, 404, `/nonsense returned ${notFound.status}`);
  console.log('PASS /nonsense -> 404');

  const game = await get('/');
  assert.strictEqual(game.status, 200, `/ returned ${game.status}`);
  console.log('PASS / -> 200');

  console.log('All tests passed.');
  process.exit(0);
}

run().catch(err => {
  console.error('FAIL', err.message);
  process.exit(1);
});
