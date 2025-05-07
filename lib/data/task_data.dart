import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/local_storage_service.dart';

/// ChangeNotifier class to manage the state of tasks
class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  final LocalStorageService _storageService = LocalStorageService();
  final _uuid = const Uuid();

  // Constructor - load tasks from storage when initialized
  TaskData() {
    loadTasks();
  }

  // Getter for tasks
  List<Task> get tasks => _tasks;

  // Getter for task count
  int get taskCount => _tasks.length;

  // Getter for completed task count
  int get completedTaskCount => _tasks.where((task) => task.isDone).length;

  // Load tasks from local storage
  Future<void> loadTasks() async {
    _tasks = await _storageService.loadTasks();
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String title) async {
    if (title.isEmpty) return;
    
    final task = Task(
      id: _uuid.v4(), // Generate a unique ID
      title: title,
    );
    
    _tasks.add(task);
    await _saveTasksToStorage();
    notifyListeners();
  }

  // Update task completion status
  Future<void> toggleTaskStatus(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        isDone: !_tasks[taskIndex].isDone,
      );
      await _saveTasksToStorage();
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasksToStorage();
    notifyListeners();
  }

  // Update a task
  Future<void> updateTask(Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      await _saveTasksToStorage();
      notifyListeners();
    }
  }

  // Save tasks to local storage
  Future<void> _saveTasksToStorage() async {
    await _storageService.saveTasks(_tasks);
  }
}
