import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/Model/task_model.dart';

final currentUserProvider = StateProvider<String>((ref) {
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  if (uid != null) {
    return uid;
  } else {
    return "null";
  }
});

final newTask = StateProvider<Task>((ref) {
  return Task(
      id: DateTime.now().toString(),
      title: "newTask",
      description: "",
      dueDate: DateTime.now(),
      priority: "low",
      ownerId: "");
});

final heightProvider = StateProvider<double>((ref) {
  return 0;
});

final widthProvider = StateProvider<double>((ref) {
  return 0;
});

final currentDateTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final taskToEditProvider = StateProvider<Task?>((ref) {
  return null;
});

final userProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());


  


