import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String title;
  final bool completed;
  final Function(bool)? onToggle;

  const TodoItem({
    super.key,
    required this.title,
    required this.completed,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${completed ? "Task Completed 🌈 Boom!" : "Open 👀"}",
          style: TextStyle(
            color: completed ? Colors.green : Colors.red,
          ),
        ),
        trailing: Checkbox(
          value: completed,
          onChanged: (value) {
            onToggle?.call(value ?? false);
          },
        ),
      ),
    );
  }
}
