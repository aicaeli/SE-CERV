// server.js
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const PORT = 4000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Import routes
const userRoutes = require("./routes/users");
app.use("/api/users", userRoutes);

// Default route
app.get("/", (req, res) => {
  res.json({ status: "CERV Profile Service running" });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
