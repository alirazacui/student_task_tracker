import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';
import '../widgets/softia_logo.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<dynamic> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final data = await ApiService.callApi(endpoint: 'students');
      setState(() {
        _students = data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching students: $e')),
        );
      }
    }
  }

  Future<void> _uploadExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      try {
        final response = await ApiService.uploadFile(
          endpoint: 'admin/students/upload',
          filePath: result.files.single.name,
          fileBytes: result.files.single.bytes!,
        );

        if (response['success'] == true) {
          await _fetchStudents();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added ${response['added']} students')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Add New Student',
          style: TextStyle(color: AppTheme.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Implement add student API call here if needed
              Navigator.pop(ctx);
              await _fetchStudents();
            },
            child: const Text('Add Student'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SoftiaLogo(),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.fileExcel,
              color: AppTheme.accent,
            ),
            onPressed: _uploadExcel,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primary),
            onPressed: _showAddStudentDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _students.map((student) {
                  return DataRow(
                    cells: [
                      DataCell(Text(student['name'])),
                      DataCell(Text(student['email'])),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _deleteStudent(student['_id']),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Future<void> _deleteStudent(String id) async {
    try {
      await ApiService.callApi(
        endpoint: 'admin/students/$id',
        method: 'DELETE',
      );
      await _fetchStudents();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: ${e.toString()}')),
        );
      }
    }
  }
}