import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/task_model.dart'; // Import your Task model

////////DEMANDE EXPLICATION
///TASK LIST PROVIDER DEVRAIS ETRE CREER DANS QUELLE PAGE?????
///CREER UN POUR CHAQUE PAGE???????
/// 
class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  void editTask(Task updatedTask) {
    state = state.map((task) => task.id == updatedTask.id ? updatedTask : task).toList();
  }
}
  



  


