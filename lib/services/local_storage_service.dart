import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Service responsible for local storage operations
class LocalStorageService {
  static const String _tasksKey = 'tasks';

  // Save tasks to local storage
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert list of Task objects to list of JSON strings
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    
    // Save the JSON strings list to SharedPreferences
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Load tasks from local storage
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get the list of JSON strings from SharedPreferences
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    
    // Convert JSON strings to Task objects
    return tasksJson
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  // Clear all tasks from local storage
  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
