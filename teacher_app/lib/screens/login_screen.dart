import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await ApiService.callApi(
          endpoint: 'auth/login',
          method: 'POST',
          body: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        );

        if (!mounted) return;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_token', response['token']);
        Navigator.pushReplacementNamed(context, '/dashboard');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.rightToBracket,
                  size: 50,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) => 
                    value!.contains('@') ? null : 'Invalid email',
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) =>
                    value!.length >= 6 ? null : 'Min 6 characters',
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.rightToBracket),
                  label: const Text('Login as Admin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}