'use strict';
const http = require('http');
const fs   = require('fs');
const path = require('path');

const PORT = process.env.PORT || 8080;
const FILE = path.join(__dirname, 'index.html');

const server = http.createServer((req, res) => {
  // Health check and game page — serve index.html for any GET /
  if (req.method !== 'GET') {
    res.writeHead(405, { 'Content-Type': 'text/plain' });
    return res.end('Method Not Allowed');
  }
  fs.readFile(FILE, (err, data) => {
    if (err) {
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      return res.end('Internal Server Error');
    }
    res.writeHead(200, {
      'Content-Type': 'text/html; charset=utf-8',
      'Content-Length': Buffer.byteLength(data),
      'Cache-Control': 'no-cache'
    });
    res.end(data);
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Snake game server running on port ${PORT}`);
});
