const express = require("express");
const next = require("next");

async function createServer() {
  const dev = process.env.NODE_ENV !== "production";
  const app = next({ dev });
  const handle = app.getRequestHandler();

  await app.prepare();

  const server = express();

  // Simple API route
  server.get("/api/hello", (req, res) => {
    res.json({ message: "Hello from Express API!" });
  });

  // All other routes handled by Next
  server.all("*", (req, res) => {
    return handle(req, res);
  });

  return server;
}

module.exports = createServer;
