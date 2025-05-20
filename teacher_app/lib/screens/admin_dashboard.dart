import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import '../models/task.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Student> _students = [];
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final studentsData = await ApiService.getStudents();
      final tasksData = await ApiService.getTasks();

      setState(() {
        _students = studentsData.map((json) => Student.fromJson(json)).toList();
        _tasks = tasksData.map((json) => Task.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCards(),
                      const SizedBox(height: 24),
                      _buildStudentsList(),
                      const SizedBox(height: 24),
                      _buildTasksList(),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tasks');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Total Students',
          _students.length.toString(),
          Icons.people,
        ),
        _buildStatCard('Total Tasks', _tasks.length.toString(), Icons.task),
        _buildStatCard(
          'Completed Tasks',
          _tasks.where((task) => task.status == 'completed').length.toString(),
          Icons.check_circle,
        ),
        _buildStatCard(
          'Pending Tasks',
          _tasks.where((task) => task.status == 'pending').length.toString(),
          Icons.pending,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Students',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _students.length > 5 ? 5 : _students.length,
          itemBuilder: (context, index) {
            final student = _students[index];
            return ListTile(
              leading: CircleAvatar(child: Text(student.name[0])),
              title: Text(student.name),
              subtitle: Text(student.email),
              trailing: IconButton(
                icon: const Icon(Icons.assignment),
                onPressed: () {
                  // TODO: Navigate to student tasks
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTasksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tasks.length > 5 ? 5 : _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return ListTile(
              leading: Icon(
                task.status == 'completed' ? Icons.check_circle : Icons.pending,
                color:
                    task.status == 'completed' ? Colors.green : Colors.orange,
              ),
              title: Text(task.title),
              subtitle: Text('Due: ${task.dueDate.toString().split(' ')[0]}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Edit task
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
