import 'package:flutter/material.dart';
import 'package:questify_task_mobile/models/task.dart';

class ListManagerService {
  final BuildContext context;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final Function onAdd;
  final Function onDelete;
  final Function onComplete;
  final Function onEdit;

  ListManagerService({
    required this.context,
    required this.onAdd,
    required this.onEdit,
    required this.onComplete,
    required this.onDelete,
  });

  void addTask() => _addTask();
  void deleteTask(String id) => _deleteTask(id);
  void editTask(Task task) => _editTask(task);
  void completeTask(Task task) => _onComplete(task);

  void _onComplete(Task task) {
    onComplete(task);
  }

  void _deleteTask(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to delete the task?'),
        content: Column(mainAxisSize: MainAxisSize.min),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              onDelete(id);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _editTask(Task task) {
    titleController.text = task.title;
    costController.text = task.coins.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  costController.text.isNotEmpty) {
                task.title = titleController.text;
                task.coins = int.tryParse(costController.text) ?? 0;
                onEdit(task);
                titleController.clear();
                costController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  costController.text.isNotEmpty) {
                onAdd(
                  titleController.text,
                  int.tryParse(costController.text) ?? 0,
                );
                titleController.clear();
                costController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
