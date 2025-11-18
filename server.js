const createServer = require("./createServer");

const port = process.env.PORT || 3000;

createServer().then((server) => {
  server.listen(port, () => {
    console.log(`> Ready on http://localhost:${port}`);
  });
}).catch((err) => {
  console.error("Error starting server:", err);
  process.exit(1);
});
