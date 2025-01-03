import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final Map<String, dynamic> todo;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggleComplete,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: onToggleComplete,
        child: Text(
          todo['isCompleted'] ? '✅' : '❌',
          style: const TextStyle(fontSize: 25),
        ),
      ),
      title: Text(
        todo['title'],
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(todo['description']),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
