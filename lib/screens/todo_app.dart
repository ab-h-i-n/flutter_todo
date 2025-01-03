import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/add_todo_button.dart';
import 'package:todo_flutter/widgets/todo_list.dart';
import 'package:todo_flutter/widgets/user_avatar.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgImage.png'),
              fit: BoxFit.cover,
              opacity: 0.7),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 100,
                    height: 100,
                  ),
                  UserAvatar(),
                ],
              ),
            ),
          ),
          body: ToDoBody(),
        ),
      ),
    );
  }
}

class ToDoBody extends StatelessWidget {
  const ToDoBody({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
        TodoList(),
        if (user != null)
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 35,
            child: Center(
              child: AddTodoButton(),
            ),
          ),
      ],
    );
  }
}
