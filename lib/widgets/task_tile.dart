import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

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
