import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../models/student.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  ReportsScreenState createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen> {
  Map<String, dynamic> _reportData = {};
  List<Student> _students = [];
  String? _selectedStudentId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final studentsData = await ApiService.getStudents();
      setState(() {
        _students = studentsData.map((json) => Student.fromJson(json)).toList();
        if (_students.isNotEmpty) {
          _selectedStudentId = _students.first.id;
          _fetchReportData();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load students: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _fetchReportData() async {
    if (_selectedStudentId == null) return;

    try {
      setState(() => _isLoading = true);
      final data = await ApiService.callApi(
        endpoint: '${ApiEndpoints.getReport}/${_selectedStudentId}',
      );
      setState(() {
        _reportData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load report: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Reports'),
        backgroundColor: AppTheme.primary,
      ),
      body:
          _students.isEmpty
              ? const Center(child: Text('No students available'))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedStudentId,
                      decoration: const InputDecoration(
                        labelText: 'Select Student',
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
                        if (value != null) {
                          setState(() => _selectedStudentId = value);
                          _fetchReportData();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildSummaryCards(),
                                  const SizedBox(height: 20),
                                  Expanded(child: _buildPerformanceChart()),
                                ],
                              ),
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Completed Tasks',
            value: _reportData['completed_tasks'].toString(),
            color: Colors.green,
            icon: Icons.check_circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            title: 'Pending Tasks',
            value: _reportData['pending_tasks'].toString(),
            color: Colors.orange,
            icon: Icons.pending_actions,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: _reportData['performance_score'].toDouble(),
                color: AppTheme.accent, // Fixed from _accent
                width: 20,
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => const Text('Performance Score'),
            ),
          ),
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
