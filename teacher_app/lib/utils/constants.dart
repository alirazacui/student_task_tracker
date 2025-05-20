class ApiEndpoints {
  // Local development server
  static const String generalBaseUrl = "http://192.168.137.246:5000/api";
  static const String adminBaseUrl = "$generalBaseUrl/admin";

  // Auth
  static const String login = "$generalBaseUrl/auth/login";

  // Admin Routes
  static const String uploadStudents = "$adminBaseUrl/students/upload";
  static const String assignTask = "$adminBaseUrl/tasks/assign";
  static const String deleteStudent = "$adminBaseUrl/students";
  static const String fetchStudents = "$adminBaseUrl/students";
  static const String fetchTasks = "$adminBaseUrl/tasks";
  static const String getReport = "$adminBaseUrl/reports";
}
