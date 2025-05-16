const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/db");

// Load environment variables
dotenv.config();

// Connect to MongoDB
connectDB();

// Initialize Express
const app = express();
app.use(express.json()); // Parse JSON data

const studentRoutes = require("./routes/studentRoutes");
app.use("/api/students", studentRoutes);
// Test endpoint
app.get("/", (req, res) => {
  res.send("Hello from Student Task Tracker API!");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});