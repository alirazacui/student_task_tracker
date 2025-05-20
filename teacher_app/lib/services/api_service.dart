import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Development URLs
  static const String _devBaseUrl =
      'http://10.0.2.2:5000/api'; // Android emulator
  static const String _devBaseUrlIOS =
      'http://localhost:5000/api'; // iOS simulator

  // Production URL - Replace this with your Render.com URL
  static const String _prodBaseUrl = 'https://your-app-name.onrender.com/api';

  // Set this to true when deploying to production
  static const bool _isProduction = false;

  static String get baseUrl {
    if (_isProduction) {
      return _prodBaseUrl;
    }

    const bool isAndroid = bool.fromEnvironment('dart.vm.product') == false;
    return isAndroid ? _devBaseUrl : _devBaseUrlIOS;
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_token');
  }

  static Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json'};
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {'Content-Type': 'application/json', 'x-auth-token': token ?? ''};
  }

  static Future<dynamic> callApi({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.Request(method, url)
      ..headers['x-auth-token'] = token ?? ''
      ..headers['Content-Type'] = 'application/json';

    if (body != null) response.body = json.encode(body);
    final streamed = await response.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('API Error ${res.statusCode}: ${res.body}');
    }
  }

  // Special method for file uploads
  static Future<dynamic> uploadFile({
    required String endpoint,
    required String filePath,
    required List<int> fileBytes,
  }) async {
    final token = await _getToken();
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/$endpoint'))
          ..headers['x-auth-token'] = token ?? ''
          ..files.add(
            http.MultipartFile.fromBytes('file', fileBytes, filename: filePath),
          );

    final response = await request.send();
    final res = await http.Response.fromStream(response);
    return json.decode(res.body);
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _getHeaders(),
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': 'admin',
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Admin endpoints
  static Future<List<dynamic>> getStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/students'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch students: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/tasks'),
        headers: await _getAuthHeaders(),
        body: json.encode(taskData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<List<dynamic>> getTasks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/tasks'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch tasks: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> updateTask(
    String taskId,
    Map<String, dynamic> taskData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/tasks/$taskId'),
        headers: await _getAuthHeaders(),
        body: json.encode(taskData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/tasks/$taskId'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> addStudent(Map<String, dynamic> studentData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/students'),
        headers: await _getAuthHeaders(),
        body: json.encode(studentData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add student: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> updateStudent(
    String studentId,
    Map<String, dynamic> studentData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/students/$studentId'),
        headers: await _getAuthHeaders(),
        body: json.encode(studentData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update student: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<void> deleteStudent(String studentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/students/$studentId'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete student: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
