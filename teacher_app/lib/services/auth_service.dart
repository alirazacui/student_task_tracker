import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('admin_token');
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    _token = null;
    notifyListeners();
  }
}