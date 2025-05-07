// Class representing a Task object
class Task {
  String id; // Unique identifier for the task
  String title; // Title/description of the task
  bool isDone; // Status of the task (completed or not)

  // Constructor with named parameters and default values
  Task({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  // Factory constructor to create a Task from a JSON object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
    );
  }

  // Method to convert a Task to a JSON object for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  // Method to create a copy of the task with modified properties
  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
