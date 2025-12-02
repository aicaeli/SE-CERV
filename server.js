//server.js
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const path = require("path");
const multer = require("multer");
const { initDb } = require("./db");

const app = express();
const PORT = process.env.PORT || 4000;

//Middleware
app.use(cors());
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));

//File upload configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, "uploads"));
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + "-" + uniqueSuffix + path.extname(file.originalname));
  },
});
const upload = multer({ storage });

//Serve uploaded files statically
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

//Import routes
const userRoutes = require("./routes/users");
const reportRoutes = require("./routes/reports");
const communityRoutes = require("./routes/community");

app.use("/api/users", userRoutes);
app.use("/api/reports", reportRoutes);
app.use("/api/community", communityRoutes);

//Default route
app.get("/", (req, res) => {
  res.json({ 
    status: "CERV Backend running", 
    version: "1.0.0",
    endpoints: {
      auth: "/api/users/register, /api/users/login",
      users: "/api/users/:id, /api/users/:id/profile",
      reports: "/api/reports (GET/POST), /api/reports/:id",
      community: "/api/community/highlights"
    }
  });
});

//Initialize database
(async () => {
  try {
    await initDb();
    console.log("Database initialized");
  } catch (err) {
    console.error("Database initialization error:", err);
  }
})();

//Start server
app.listen(PORT, () => {
  console.log(`✅ CERV Backend running at http://localhost:${PORT}`);
});
