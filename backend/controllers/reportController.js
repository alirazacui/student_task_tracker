const Report = require("../models/Report");
const User = require("../models/User");
const Task = require("../models/Task");

exports.generateStudentReport = async (req, res) => {
  try {
    const studentId = req.params.studentId;
    
    const [student, tasks] = await Promise.all([
      User.findById(studentId),
      Task.find({ assigned_to: studentId })
    ]);

    if (!student) return res.status(404).json({ error: "Student not found" });

    const completed = tasks.filter(t => t.status === "completed").length;
    const pending = tasks.length - completed;
    const performance = Math.round((completed / tasks.length) * 100) || 0;

    const report = await Report.findOneAndUpdate(
      { student_id: studentId },
      {
        completed_tasks: completed,
        pending_tasks: pending,
        performance_score: performance
      },
      { upsert: true, new: true }
    );

    res.json(report);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};