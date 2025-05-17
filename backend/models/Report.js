const mongoose = require("mongoose");

const reportSchema = new mongoose.Schema({
  student_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
    unique: true
  },
  completed_tasks: {
    type: Number,
    default: 0
  },
  pending_tasks: {
    type: Number,
    default: 0
  },
  performance_score: {
    type: Number,
    default: 0
  },
  last_updated: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model("Report", reportSchema);