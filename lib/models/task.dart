class Task {
  final String id;
  String title;
  int coins;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.coins,
    this.isCompleted = false,
  });

  // Convert a Task object into a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coins': coins,
      'isCompleted': isCompleted,
    };
  }

  // Create a Task object from a Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      coins: json['coins'],
      isCompleted: json['isCompleted'],
    );
  }
}
