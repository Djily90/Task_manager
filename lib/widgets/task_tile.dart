import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../screens/edit_task_screen.dart';

/// Widget representing a single task item in the list
class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onDelete,
  });

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
          style: task.isDone
              ? AppTextStyles.taskCompleted
              : AppTextStyles.taskPending,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                _showEditTaskBottomSheet(context);
              },
            ),
            // Delete button
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.deleteColor,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  // Show the bottom sheet for editing a task
  void _showEditTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => EditTaskScreen(task: task),
    );
  }
}
