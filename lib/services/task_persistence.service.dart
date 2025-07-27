// lib/services/coin_service.dart
import 'dart:convert';
import 'package:questify_task_mobile/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPersistenceService {
  final String _key;

  TaskPersistenceService({required String context}) : _key = 'list_$context';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((item) => Task.fromJson(jsonDecode(item))).toList();
  }

  Future<void> savetasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final list = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_key, list);
  }

  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await savetasks(tasks);
  }

  Future<void> removeTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await savetasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await savetasks(tasks);
    }
  }
}
