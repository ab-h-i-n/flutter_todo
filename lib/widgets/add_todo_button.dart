import 'package:flutter/material.dart';
import '../widgets/add_todo_dialog.dart';

class AddTodoButton extends StatelessWidget {
  const AddTodoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AddTodoDialog();
          },
        );
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
