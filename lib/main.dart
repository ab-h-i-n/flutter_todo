import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoApp(),
    );
  }
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  List<Map<String, String>> todoItems = [
    {"title": 'Task 1', "description": 'Description 1', "id": 'dlfsldjfl'},
    {"title": 'Task 2', "description": 'Description 2', "id": 'dlfsldjfl'},
    {"title": 'Task 3', "description": 'Description 3', "id": 'dlfsldjfl'},
    {"title": 'Task 4', "description": 'Description 4', "id": 'dlfsldjfl'},
    {"title": 'Task 5', "description": 'Description 5', "id": 'dlfsldjfl'},
    {"title": 'Task 6', "description": 'Description 6', "id": 'dlfsldjfl'},
    {"title": 'Task 7', "description": 'Description 7', "id": 'dlfsldjfl'},
    {"title": 'Task 8', "description": 'Description 8', "id": 'dlfsldjfl'},
    {"title": 'Task 9', "description": 'Description 9', "id": 'dlfsldjfl'},
    {"title": 'Task 10', "description": 'Description 10', "id": 'dlfsldjfl'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgImage.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 130,
            backgroundColor: Colors.transparent,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: todoItems.length +
                        1, // Increase itemCount to add space for the extra item
                    itemBuilder: (context, index) {
                      if (index == todoItems.length) {
                        // Return a SizedBox for the space after the last item
                        return const SizedBox(
                            height: 20); // Adjust the height for spacing
                      }
                      return Container(
                        margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        padding: const EdgeInsets.all(25),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromRGBO(236, 236, 255, 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(57, 0, 0, 0),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(0, 2))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todoItems[index]["title"]!,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 2,
                              color: const Color.fromARGB(27, 0, 0, 0),
                              margin: EdgeInsets.symmetric(vertical: 10),
                            ),
                            Text(todoItems[index]["description"]!),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3b69dd),
                      iconColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: CircleBorder(),
                      elevation: 10,
                    ),
                    onPressed: () => _showAddTodoDialog(context),
                    child: const Icon(
                      Icons.add,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: const Text('Add a new task'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Enter your task title'),
                ),
                TextField(
                  controller: descController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your task description'),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descController.text.isNotEmpty) {
                  setState(() {
                    todoItems.add({
                      "title": titleController.text,
                      "description": descController.text,
                      "id": 'dlfsldjfl'
                    });
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
