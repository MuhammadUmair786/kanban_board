import 'package:flutter/material.dart';
import 'package:kanban_board/models/task_model.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Text(widget.taskModel.title),
          Text(widget.taskModel.description),
        ],
      ),
    );
  }
}
