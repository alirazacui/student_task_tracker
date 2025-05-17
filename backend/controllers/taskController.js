const Task = require("../models/Task");
const User = require("../models/User");

exports.assignTask = async (req, res) => {
  try {
    const { title, description, assigned_to, due_date } = req.body;
    
    const task = await Task.create({
      title,
      description,
      assigned_to,
      due_date: new Date(due_date),
      created_by: req.user.id
    });

    res.status(201).json(task);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};

exports.getStudentTasks = async (req, res) => {
  try {
    const tasks = await Task.find({ assigned_to: req.user.id })
      .populate("created_by", "name email");
      
    res.json(tasks);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};

exports.markTaskCompleted = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    
    if (!task) return res.status(404).json({ error: "Task not found" });
    if (task.assigned_to.toString() !== req.user.id) {
      return res.status(403).json({ error: "Not authorized" });
    }

    task.status = "completed";
    await task.save();
    
    res.json(task);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};