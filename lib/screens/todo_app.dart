import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/add_todo_button.dart';
import 'package:todo_flutter/widgets/todo_list.dart';
import 'package:todo_flutter/widgets/user_avatar.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/bgImage.png'),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 130,
            backgroundColor: Colors.transparent,
            actions: [UserAvatar()],
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset('assets/logo.png'),
            ),
          ),
          body: ToDoBody(),
        ),
      ),
    );
  }
}

class ToDoBody extends StatelessWidget {
  const ToDoBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final User? user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
        TodoList(),
        user != null ? AddTodoButton() : const SizedBox.shrink(),
      ],
    );
  }
}
