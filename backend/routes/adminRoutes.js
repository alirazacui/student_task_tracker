const express = require("express");
const router = express.Router();
const { verifyToken } = require("../middleware/auth");
const { adminCheck } = require("../middleware/roleCheck");
const { 
  uploadStudents,
  assignTask 
} = require("../controllers/studentController"); // Verify this path
const { generateStudentReport } = require("../controllers/reportController");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

// Verify middleware order
router.use(verifyToken);
router.use(adminCheck);

// Define routes
router.post("/students/upload", upload.single("file"), uploadStudents);
router.post("/tasks/assign", assignTask);
router.get("/reports/:studentId", generateStudentReport);

module.exports = router;