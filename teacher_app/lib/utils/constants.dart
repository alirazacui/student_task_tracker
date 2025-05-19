class ApiEndpoints {
  // Replace with your actual IP (e.g., 10.0.2.2 for Android emulator)
  static const String generalBaseUrl = "http://10.0.2.2:5000/api";
  static const String adminBaseUrl = "$generalBaseUrl/admin";

  // Auth
  static const String login = "$generalBaseUrl/auth/login";
  
  // Admin Routes
  static const String uploadStudents = "$adminBaseUrl/students/upload";
  static const String assignTask = "$adminBaseUrl/tasks/assign";
  static const String deleteStudent = "$adminBaseUrl/students";
  static const String fetchStudents = "$adminBaseUrl/students";
  static const String fetchTasks = "$adminBaseUrl/tasks";
}