// routes/users.js
const express = require("express");
const router = express.Router();

let users = []; // Temporary storage (you can replace with database later)

// 🧾 Register a new user
router.post("/register", (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  // Check if email already exists
  const existingUser = users.find((u) => u.email === email);
  if (existingUser) {
    return res.status(400).json({ message: "Email already registered" });
  }

  const newUser = { id: users.length + 1, username, email, password };
  users.push(newUser);
  res.status(201).json({ message: "User registered successfully", user: newUser });
});

// 🔐 Login
router.post("/login", (req, res) => {
  const { email, password } = req.body;
  const user = users.find((u) => u.email === email && u.password === password);

  if (!user) {
    return res.status(401).json({ message: "Invalid email or password" });
  }

  res.json({ message: "Login successful", user });
});

// 👤 Get all users (for testing only)
router.get("/", (req, res) => {
  res.json(users);
});

module.exports = router;
