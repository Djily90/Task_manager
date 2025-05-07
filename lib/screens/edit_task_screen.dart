import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_data.dart';
import '../models/task.dart';
import '../utils/constants.dart';

/// Screen for editing an existing task
class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.title);
    _taskController.addListener(_validateInput);
    _validateInput(); // Check initial validity
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  // Validate input to enable/disable the save button
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
            'Modifier la tâche',
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
            onPressed: _isInputValid ? _saveTask : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Enregistrer',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    final taskData = Provider.of<TaskData>(context, listen: false);
    final taskTitle = _taskController.text.trim();

    if (taskTitle.isNotEmpty) {
      // Create an updated copy of the task with the new title
      final updatedTask = widget.task.copyWith(
        title: taskTitle,
      );

      taskData.updateTask(updatedTask);
      Navigator.pop(context);
    }
  }
}
