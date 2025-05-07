import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../models/task.dart';
import 'task_tile.dart';

/// Widget for displaying the list of tasks
class TaskList extends StatelessWidget {
  const TaskList({super.key});

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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
