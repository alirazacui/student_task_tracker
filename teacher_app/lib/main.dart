import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/students_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/reports_screen.dart';
import 'services/auth_service.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const SoftiaAdminApp(),
    ),
  );
}

class SoftiaAdminApp extends StatelessWidget {
  const SoftiaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Softia Admin',
      theme: AppTheme.lightTheme, // Corrected theme reference
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const AdminDashboard(),
        '/students': (context) => const StudentsScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}