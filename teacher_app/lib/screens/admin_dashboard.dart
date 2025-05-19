import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/stats_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                StatsCard(
                  title: "Total Students",
                  value: "142",
                  icon: FontAwesomeIcons.users,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 16),
                StatsCard(
                  title: "Tasks Today",
                  value: "23",
                  icon: FontAwesomeIcons.tasks,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add your bar chart here using FlChart
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    Navigator.pushReplacementNamed(context, '/login');
  }
}