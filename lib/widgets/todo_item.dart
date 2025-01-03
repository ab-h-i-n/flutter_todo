import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoItem extends StatelessWidget {
  final Map<String, dynamic> todo;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      onTap: onToggleComplete,
      onLongPress: onDelete,
      splashColor: const Color.fromARGB(50, 255, 255, 255),
      title: Text(
        todo['title'],
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily),
      ),
      subtitle: Text(todo['description'],
          style: TextStyle(
              fontSize: 15, fontFamily: GoogleFonts.poppins().fontFamily)),
      trailing: Text(
        todo['isCompleted'] ? '✅' : '❌',
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}
