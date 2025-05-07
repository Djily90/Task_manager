import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../utils/constants.dart';
import '../widgets/task_list.dart';
import 'add_task_screen.dart';

/// Main screen of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
