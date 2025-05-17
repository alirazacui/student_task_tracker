// controllers/studentController.js
const User = require("../models/User");
const Task = require("../models/Task");
const parseExcel = require("../utils/excelParser");
const bcrypt = require("bcrypt");

exports.uploadStudents = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ 
        success: false,
        error: "No file uploaded" 
      });
    }

    const students = await parseExcel(req.file.buffer);
    const results = {
      success: [],
      errors: []
    };

    // Process students in parallel
    await Promise.all(students.map(async (student) => {
      try {
        const exists = await User.findOne({ email: student.email });
        if (exists) {
          results.errors.push({
            email: student.email,
            message: "User already exists"
          });
          return;
        }

        const hashedPassword = await bcrypt.hash(student.password, 10);
        await User.create({
          ...student,
          password: hashedPassword,
        });
        results.success.push(student.email);
      } catch (error) {
        results.errors.push({
          email: student.email,
          message: error.message
        });
      }
    }));

    res.json({
      success: true,
      added: results.success.length,
      errors: results.errors
    });

  } catch (err) {
    console.error("Excel Upload Error:", err);
    res.status(500).json({
      success: false,
      error: "Failed to process Excel file",
      details: err.message
    });
  }
};

// Add this new controller function
exports.assignTask = async (req, res) => {
  try {
    const { title, description, assigned_to, due_date } = req.body;
    
    // Validate student exists
    const student = await User.findById(assigned_to);
    if (!student || student.role !== "student") {
      return res.status(400).json({
        success: false,
        error: "Invalid student ID"
      });
    }

    const newTask = await Task.create({
      title,
      description,
      assigned_to,
      due_date: new Date(due_date),
      created_by: req.user.id,
      status: "pending"
    });

    res.status(201).json({
      success: true,
      task: newTask
    });

  } catch (err) {
    console.error("Task Assignment Error:", err);
    res.status(500).json({
      success: false,
      error: "Failed to assign task",
      details: err.message
    });
  }
};