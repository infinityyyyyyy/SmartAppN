// lib/models/task_model.dart

class TodoTask {
  String title;
  bool isCompleted;
  String category;
  String priority;
  DateTime date; // Görevin ait olduğu gün (Tarih bazlı filtreleme için)

  TodoTask({
    required this.title,
    this.isCompleted = false,
    required this.category,
    required this.priority,
    required this.date,
  });
}