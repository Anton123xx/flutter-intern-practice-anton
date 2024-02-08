class Task {
  String title;
  String description;
  DateTime dueDate;
  String priority;
  String ownerId;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.ownerId,
  });
}