const express = require("express");
const router = express.Router();
const { uploadStudents } = require("../controllers/studentController");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

// POST /api/students/upload (Excel upload)


module.exports = router;

const { adminCheck } = require("../middleware/roleCheck");

router.post("/upload", adminCheck, upload.single("file"), uploadStudents);

