class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  String status;
  final DateTime dueDate;
  final String createdBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    required this.createdBy,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assigned_to'],
      status: json['status'],
      dueDate: DateTime.parse(json['due_date']),
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'status': status,
      'due_date': dueDate.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
