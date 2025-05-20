import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;

  const TaskTile({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.task, color: AppColors.accent),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            "Due: ${DateFormat('MMM dd, yyyy').format(dueDate)}",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: Chip(
        label: Text(status.toUpperCase()),
        backgroundColor:
            status == "completed"
                ? Colors.green.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
      ),
    );
  }
}
