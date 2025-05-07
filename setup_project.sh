#!/bin/bash

# Script de configuration du projet Flutter pour l'application de gestion de tâches
# Créé le $(date)

# Couleurs pour le texte
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==== Configuration du projet d'application de gestion de tâches ====${NC}"

# Vérifier si nous sommes dans un projet Flutter
if [ ! -f "pubspec.yaml" ]; then
  echo -e "${RED}Erreur: Ce script doit être exécuté à la racine d'un projet Flutter.${NC}"
  echo "Créez d'abord un projet avec 'flutter create task_manager', puis exécutez ce script."
  exit 1
fi

# Créer les dossiers nécessaires
echo -e "${GREEN}Création de la structure des dossiers...${NC}"
mkdir -p lib/models
mkdir -p lib/data
mkdir -p lib/services
mkdir -p lib/screens
mkdir -p lib/widgets
mkdir -p lib/utils

# Mise à jour du pubspec.yaml
echo -e "${GREEN}Mise à jour du fichier pubspec.yaml...${NC}"
cat > pubspec.yaml << 'EOL'
name: task_manager
description: Une application de gestion de tâches.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State management
  provider: ^6.0.5
  
  # Local storage
  shared_preferences: ^2.2.0
  
  # Utilities
  uuid: ^3.0.7
  intl: ^0.18.1
  
  # UI components
  cupertino_icons: ^1.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.2

flutter:
  uses-material-design: true
  
  # Add fonts if needed
  # fonts:
  #   - family: Roboto
  #     fonts:
  #       - asset: fonts/Roboto-Regular.ttf
  #       - asset: fonts/Roboto-Bold.ttf
  #         weight: 700
EOL

# Création des fichiers de l'application
echo -e "${GREEN}Création des fichiers de l'application...${NC}"

# 1. Fichier du modèle Task
cat > lib/models/task.dart << 'EOL'
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
EOL

# 2. Fichier de service de stockage local
cat > lib/services/local_storage_service.dart << 'EOL'
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
EOL

# 3. Fichier de gestion des données des tâches
cat > lib/data/task_data.dart << 'EOL'
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
EOL

# 4. Fichier des constantes
cat > lib/utils/constants.dart << 'EOL'
import 'package:flutter/material.dart';

/// This file contains all the constants used in the app
class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF4A67FF);
  static const Color secondaryColor = Color(0xFF6C8EFF);
  static const Color accentColor = Color(0xFF344BD0);
  
  // Text colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  
  // Task status colors
  static const Color taskCompleted = Color(0xFF28A745);
  static const Color taskPending = Color(0xFFFFC107);
  
  // UI element colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color deleteColor = Color(0xFFDC3545);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subheading = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 14.0,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    color: AppColors.textSecondary,
  );
  
  static TextStyle taskCompleted = const TextStyle(
    fontSize: 16.0,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );
  
  static const TextStyle taskPending = TextStyle(
    fontSize: 16.0,
    color: AppColors.textPrimary,
  );
}

class AppDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class AppPadding {
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
  static const double itemSpacing = 12.0;
}
EOL

# 5. Fichier du widget TaskTile
cat > lib/widgets/task_tile.dart << 'EOL'
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

/// Widget representing a single task item in the list
class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onDelete;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: AppDecorations.cardDecoration,
      child: ListTile(
        contentPadding: AppPadding.cardPadding,
        leading: Checkbox(
          activeColor: AppColors.primaryColor,
          value: task.isDone,
          onChanged: onCheckboxChanged,
        ),
        title: Text(
          task.title,
          style: task.isDone ? AppTextStyles.taskCompleted : AppTextStyles.taskPending,
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: AppColors.deleteColor,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
EOL

# 6. Fichier du widget TaskList
cat > lib/widgets/task_list.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../models/task.dart';
import 'task_tile.dart';

/// Widget for displaying the list of tasks
class TaskList extends StatelessWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return taskData.taskCount == 0
            ? _buildEmptyState()
            : _buildTaskList(taskData);
      },
    );
  }

  // Widget for when there are no tasks
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Aucune tâche à afficher',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ajoutez une tâche en utilisant le bouton en bas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget for displaying the list of tasks
  Widget _buildTaskList(TaskData taskData) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: taskData.taskCount,
      itemBuilder: (context, index) {
        final Task task = taskData.tasks[index];
        return TaskTile(
          task: task,
          onCheckboxChanged: (bool? isChecked) {
            taskData.toggleTaskStatus(task.id);
          },
          onDelete: () {
            // Optional: Show confirmation dialog before deleting
            _showDeleteConfirmation(context, task, taskData);
          },
        );
      },
    );
  }

  // Show confirmation dialog before deleting a task
  void _showDeleteConfirmation(
    BuildContext context,
    Task task,
    TaskData taskData,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer cette tâche?'),
          content: Text('Êtes-vous sûr de vouloir supprimer "${task.title}"?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                taskData.deleteTask(task.id);
                Navigator.of(context).pop();
                
                // Show a snackbar to confirm deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Tâche supprimée'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
EOL

# 7. Fichier de l'écran d'ajout de tâche
cat > lib/screens/add_task_screen.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../utils/constants.dart';

/// Screen for adding a new task
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _taskController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  // Validate input to enable/disable the add button
  void _validateInput() {
    setState(() {
      _isInputValid = _taskController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        // Adjust for the keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ajouter une tâche',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _taskController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Quelle est votre tâche?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isInputValid ? _addTask : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Ajouter',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    final taskData = Provider.of<TaskData>(context, listen: false);
    final taskTitle = _taskController.text.trim();
    
    if (taskTitle.isNotEmpty) {
      taskData.addTask(taskTitle);
      Navigator.pop(context);
    }
  }
}
EOL

# 8. Fichier de l'écran d'accueil
cat > lib/screens/home_screen.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../utils/constants.dart';
import '../widgets/task_list.dart';
import 'add_task_screen.dart';

/// Main screen of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Mes Tâches'),
        elevation: 0,
        actions: [
          // Display task count in the app bar
          Consumer<TaskData>(
            builder: (context, taskData, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    '${taskData.completedTaskCount}/${taskData.taskCount} tâches',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Expanded(
            child: TaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          // Show bottom sheet for adding a new task
          _showAddTaskBottomSheet(context);
        },
      ),
    );
  }

  // Build the header section
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Consumer<TaskData>(
        builder: (context, taskData, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour!',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                taskData.taskCount == 0
                    ? 'Vous n\'avez pas de tâches à faire aujourd\'hui.'
                    : taskData.completedTaskCount == taskData.taskCount && taskData.taskCount > 0
                        ? 'Bravo! Toutes les tâches sont terminées.'
                        : 'Vous avez ${taskData.taskCount - taskData.completedTaskCount} tâches restantes.',
                style: AppTextStyles.subheading.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
            ],
          );
        },
      ),
    );
  }

  // Show the bottom sheet for adding a task
  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => const AddTaskScreen(),
    );
  }
}
EOL

# 9. Fichier main.dart
cat > lib/main.dart << 'EOL'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/task_data.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        title: 'Gestionnaire de Tâches',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor,
            primary: AppColors.primaryColor,
            secondary: AppColors.secondaryColor,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
          ),
          fontFamily: 'Roboto',
          // Additional theming
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12, 
                horizontal: 24,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
EOL

# Installer les dépendances
echo -e "${GREEN}Installation des dépendances...${NC}"
flutter pub get

echo -e "${GREEN}Configuration terminée avec succès!${NC}"
echo -e "Pour lancer l'application, exécutez la commande: ${BLUE}flutter run${NC}"