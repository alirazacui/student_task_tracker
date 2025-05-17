const express = require("express");
const router = express.Router();
const { verifyToken } = require("../middleware/auth");
const { studentCheck } = require("../middleware/roleCheck");
const {
  getStudentTasks,
  markTaskCompleted
} = require("../controllers/taskController");

// Protected student routes
router.use(verifyToken, studentCheck);

router.get("/tasks", getStudentTasks);
router.patch("/tasks/:id/complete", markTaskCompleted);

module.exports = router;