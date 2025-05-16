const User = require("../models/User");
const parseExcel = require("../utils/excelParser");
const bcrypt = require("bcrypt");

exports.uploadStudents = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    // Parse Excel
    const students = await parseExcel(req.file.buffer);

    // Hash passwords and save students
    for (const student of students) {
      const hashedPassword = await bcrypt.hash(student.password, 10);
      await User.create({
        ...student,
        password: hashedPassword,
      });
    }

    res.json({ message: `${students.length} students added successfully!` });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};