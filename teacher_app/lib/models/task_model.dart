class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final DateTime dueDate;
  final String status;
  final String createdBy; // Added to match your Task.js

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.dueDate,
    required this.status,
    required this.createdBy,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assigned_to'],
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'],
      createdBy: json['created_by'],
    );
  }
}