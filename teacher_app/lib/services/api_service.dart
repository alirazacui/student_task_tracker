import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:5000/api";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_token');
  }

  static Future<dynamic> callApi({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    final url = Uri.parse('$_baseUrl/$endpoint');

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
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/$endpoint'))
      ..headers['x-auth-token'] = token ?? ''
      ..files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: filePath));

    final response = await request.send();
    final res = await http.Response.fromStream(response);
    return json.decode(res.body);
  }
}