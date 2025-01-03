import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_flutter/screens/login_screen.dart';
import 'package:vibration/vibration.dart';
import '../widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginScreen();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.black,
            strokeWidth: 5,
          ));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Add a new todo!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          );
        }

        final todos = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          physics: const BouncingScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoItem(
              todo: todo.data() as Map<String, dynamic>,
              onToggleComplete: () async {

                if ((await Vibration.hasVibrator()) ?? false) {
                  Vibration.vibrate(duration: 50);
                } 

                final isCompleted = todo['isCompleted'] as bool;
                await FirebaseFirestore.instance
                    .collection('todos')
                    .doc(todo.id)
                    .update({'isCompleted': !isCompleted});
              },
              onDelete: () async {

                if ((await Vibration.hasVibrator()) ?? false) {
                  Vibration.vibrate(duration: 200);
                }

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
