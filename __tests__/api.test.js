jest.mock("next", () => {
  return () => ({
    prepare: () => Promise.resolve(),
    getRequestHandler: () => {
      return (req, res) => {
        res.statusCode = 200;
        res.end("OK");
      };
    }
  });
});

const request = require("supertest");
const http = require("http");
const createServer = require("../createServer");

let app;
let httpServer;

beforeAll(async () => {
  app = await createServer();
  httpServer = http.createServer(app).listen();   // start listening
});

afterAll((done) => {
  httpServer.close(done);
});

test("GET /api/hello returns JSON message", async () => {
  const res = await request(httpServer).get("/api/hello");
  expect(res.statusCode).toBe(200);
  expect(res.body).toEqual({ message: "Hello from Express API!" });
});
