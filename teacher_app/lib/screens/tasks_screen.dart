import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  String? _selectedStudentId;
  List<User> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _fetchStudents();
  }

  Future<void> _fetchTasks() async {
    try {
      final data = await ApiService.callApi(endpoint: ApiEndpoints.fetchTasks);
      setState(() {
        _tasks = (data as List).map((task) => Task.fromJson(task)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: ${e.toString()}')),
      );
    }
  }

  Future<void> _fetchStudents() async {
    try {
      final data = await ApiService.callApi(endpoint: ApiEndpoints.fetchStudents);
      setState(() {
        _students = (data as List).map((student) => User.fromJson(student)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load students: ${e.toString()}')),
      );
    }
  }

  Future<void> _assignTask() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Assign New Task',
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme._primary,
                  fontWeight: FontWeight.bold,
                )),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              value: _selectedStudentId,
              decoration: const InputDecoration(labelText: 'Assign to Student'),
              items: _students.map((User student) {
                return DropdownMenuItem<String>(
                  value: student.id,
                  child: Text(student.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedStudentId = value),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: AppTheme._accent),
              title: Text(_selectedDueDate == null
                  ? 'Select Due Date'
                  : DateFormat('MMM dd, yyyy').format(_selectedDueDate!)),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                );
                if (date != null) {
                  setState(() => _selectedDueDate = date);
                }
              },
            ),
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.paperPlane),
              label: const Text('Assign Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme._primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () async {
                try {
                  if (_selectedStudentId == null || _selectedDueDate == null) {
                    throw Exception('Please select student and due date');
                  }

                  await ApiService.callApi(
                    endpoint: ApiEndpoints.assignTask,
                    method: 'POST',
                    body: {
                      "title": _titleController.text,
                      "description": _descriptionController.text,
                      "assigned_to": _selectedStudentId,
                      "due_date": _selectedDueDate!.toIso8601String(),
                    },
                  );

                  Navigator.pop(context);
                  await _fetchTasks();
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedStudentId = null;
                    _selectedDueDate = null;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Assignment failed: ${e.toString()}')),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme._accent,
        child: const Icon(Icons.add, size: 30),
        onPressed: _assignTask,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (ctx, index) => Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.task, color: AppTheme._primary),
            title: Text(_tasks[index].title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme._primary,
                )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_tasks[index].description),
                Text('Due: ${DateFormat('MMM dd').format(_tasks[index].dueDate)}',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            trailing: Chip(
              backgroundColor: _tasks[index].status == 'completed'
                  ? Colors.green[100]
                  : Colors.orange[100],
              label: Text(_tasks[index].status),
            ),
          ),
        ),
      ),
    );
  }
}