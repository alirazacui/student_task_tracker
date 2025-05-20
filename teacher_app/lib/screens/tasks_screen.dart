import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task.dart';
import '../models/student.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = [];
  List<Student> _students = [];
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

      final tasksData = await ApiService.getTasks();
      final studentsData = await ApiService.getStudents();

      setState(() {
        _tasks = tasksData.map((json) => Task.fromJson(json)).toList();
        _students = studentsData.map((json) => Student.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? dueDate;
    String? selectedStudentId;

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Task'),
            content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
              maxLines: 3,
            ),
                  const SizedBox(height: 16),
            DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Assign To',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _students.map((student) {
                          return DropdownMenuItem(
                  value: student.id,
                  child: Text(student.name),
                );
              }).toList(),
                    onChanged: (value) {
                      selectedStudentId = value;
                    },
            ),
                  const SizedBox(height: 16),
            ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(
                      dueDate?.toString().split(' ')[0] ?? 'Select a date',
                    ),
                    trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                        dueDate = date;
                }
              },
            ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
              onPressed: () async {
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      selectedStudentId == null ||
                      dueDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  try {
                    await ApiService.createTask({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'assigned_to': selectedStudentId,
                      'due_date': dueDate!.toIso8601String(),
                      'status': 'pending',
                    });

                    if (mounted) {
                      Navigator.pop(context);
                      _loadData();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
    );
  }

  Future<void> _showEditTaskDialog(Task task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime? dueDate = task.dueDate;
    String? selectedStudentId = task.assignedTo;

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStudentId,
                    decoration: const InputDecoration(
                      labelText: 'Assign To',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _students.map((student) {
                          return DropdownMenuItem(
                            value: student.id,
                            child: Text(student.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      selectedStudentId = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(
                      dueDate?.toString().split(' ')[0] ?? 'Select a date',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        dueDate = date;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: task.status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        task.status = value;
                }
              },
            ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      selectedStudentId == null ||
                      dueDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  try {
                    await ApiService.updateTask(task.id, {
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'assigned_to': selectedStudentId,
                      'due_date': dueDate!.toIso8601String(),
                      'status': task.status,
                    });

                    if (mounted) {
                      Navigator.pop(context);
                      _loadData();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
      ),
    );
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await ApiService.deleteTask(task.id);
        if (mounted) {
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final student = _students.firstWhere(
                      (s) => s.id == task.assignedTo,
                      orElse:
                          () => Student(
                            id: '',
                            name: 'Unknown',
                            email: '',
                            createdAt: DateTime.now(),
                          ),
                    );

                    return Card(
          child: ListTile(
                        leading: Icon(
                          task.status == 'completed'
                              ? Icons.check_circle
                              : Icons.pending,
                          color:
                              task.status == 'completed'
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                        title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                            Text(task.description),
                            const SizedBox(height: 4),
                            Text(
                              'Assigned to: ${student.name}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Due: ${task.dueDate.toString().split(' ')[0]}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditTaskDialog(task),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(task),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
