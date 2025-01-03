import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTodos(String userId) {
    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> addTodo(String userId, String title, String description) async {
    await _firestore.collection('todos').add({
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleTodoCompletion(String todoId, bool isCompleted) async {
    await _firestore.collection('todos').doc(todoId).update({'isCompleted': !isCompleted});
  }

  Future<void> deleteTodo(String todoId) async {
    await _firestore.collection('todos').doc(todoId).delete();
  }
}
