const jwt = require("jsonwebtoken");
const User = require("../models/User");

exports.adminCheck = async (req, res, next) => {
  // Get token from header
  const token = req.header("x-auth-token");
  if (!token) {
    return res.status(401).json({ error: "No token, access denied" });
  }

  try {
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.id);

    if (user.role !== "admin") {
      return res.status(403).json({ error: "Admin access required" });
    }

    req.user = user;
    next();
  } catch (err) {
    res.status(401).json({ error: "Invalid token" });
  }
};
