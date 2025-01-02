import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:accordion/accordion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            actions: [
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20, top: 40),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data!.photoURL!),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset('assets/logo.png'),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, authSnapshot) {
                      if (!authSnapshot.hasData) {
                        return Center(
                          child: Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        );
                      }
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('todos')
                            .where('userId', isEqualTo: authSnapshot.data!.uid)
                            .snapshots(),
                        builder: (context, userTodoSnapshot) {
                          if (userTodoSnapshot.hasError) {
                            return Center(child: Text('Error fetching data'));
                          }

                          if (userTodoSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final todoItems = userTodoSnapshot.data?.docs
                              .map((doc) => {
                                    'id': doc.id,
                                    'title': doc['title'],
                                    'description': doc['description'],
                                    'isCompleted': doc['isCompleted'],
                                  })
                              .toList();

                          if (todoItems == null) {
                            return Center(
                              child: Text(
                                'No todos yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            child: ListView.builder(
                              itemCount: todoItems.length + 1,
                              itemBuilder: (context, index) {
                                if (index == todoItems.length) {
                                  return const SizedBox(height: 20);
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // invert is completed

                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          if (user != null) {
                                            await FirebaseFirestore.instance
                                                .collection('todos')
                                                .doc(todoItems[index]['id'])
                                                .update({
                                              'isCompleted': !todoItems[index]
                                                  ['isCompleted']
                                            });
                                          }
                                        },
                                        child: Text(
                                          todoItems[index]['isCompleted']
                                              ? '✅'
                                              : '❌',
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onLongPress: () async {
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          if (user != null) {
                                            await FirebaseFirestore.instance
                                                .collection('todos')
                                                .doc(todoItems[index]['id'])
                                                .delete();
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                todoItems[index]['title'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(todoItems[index]
                                                  ['description'])
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3b69dd),
                          iconColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: const CircleBorder(),
                          elevation: 10,
                        ),
                        onPressed: () async {
                          if (snapshot.hasData) {
                            // User is signed in, show add todo dialog
                            _showAddTodoDialog(context);
                          } else {
                            // User is not signed in, perform sign in
                            await signInWithGoogle();
                          }
                        },
                        child: snapshot.hasData
                            ? const Icon(
                                Icons.add,
                                size: 35,
                              )
                            : SizedBox(
                                width: 35,
                                height: 35,
                                child: Image.network(
                                  'http://pngimg.com/uploads/google/google_PNG19635.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showAddTodoDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add a new task'),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration:
                    const InputDecoration(hintText: 'Enter your task title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                    hintText: 'Enter your task description'),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  descController.text.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance.collection('todos').add({
                    'userId': user.uid,
                    'title': titleController.text,
                    'description': descController.text,
                    'isCompleted': false,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
}
