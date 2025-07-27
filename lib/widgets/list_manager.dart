import 'package:flutter/material.dart';
import 'package:questify_task_mobile/models/task.dart';
import 'package:questify_task_mobile/services/list_manager_service.dart';

class ListManager extends StatefulWidget {
  final Task task;
  final ListManagerService service;
  const ListManager({super.key, required this.task, required this.service});

  @override
  State<ListManager> createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                widget.task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.service.completeTask(widget.task);
                },
                icon: Icon(Icons.done, color: Colors.green),
                tooltip: 'Complete',
              ),
              IconButton(
                onPressed: () {
                  widget.service.editTask(widget.task);
                },
                icon: Icon(Icons.edit, color: Colors.yellow),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () {
                  widget.service.deleteTask(widget.task.id);
                },
                icon: Icon(Icons.close, color: Colors.red),
                tooltip: 'Delete',
              ),
            ],
          ),
          Container(
            width: 60,
            decoration: BoxDecoration(
              color: Color(0xFFfbebd3),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              spacing: 4,
              children: [
                Image.asset('assets/img/coins.png', width: 20),
                Text(
                  widget.task.coins.toString(),
                  style: TextStyle(color: Color(0xFFA17D48)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
