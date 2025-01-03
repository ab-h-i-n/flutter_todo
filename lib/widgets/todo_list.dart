import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/signin_button.dart';
import '../widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: SigninButton());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No todos yet. Add a new one!'));
        }

        final todos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoItem(
              todo: todo.data() as Map<String, dynamic>,
              onToggleComplete: () async {
                final isCompleted = todo['isCompleted'] as bool;
                await FirebaseFirestore.instance
                    .collection('todos')
                    .doc(todo.id)
                    .update({'isCompleted': !isCompleted});
              },
              onDelete: () async {
                await FirebaseFirestore.instance
                    .collection('todos')
                    .doc(todo.id)
                    .delete();
              },
            );
          },
        );
      },
    );
  }
}
