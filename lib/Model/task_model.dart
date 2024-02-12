import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/controllers/firebaseFirestore_controller.dart';


class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  String priority;
  String ownerId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.ownerId,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Task(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['desc'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: data['priority'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }
}

class TaskList {
  //String? ownerId;
  final List<Task> list;

  TaskList({required this.list});
  
}


List<Task> taskListPassed = [];
//List<Task> taskListPassed = fetchTasksByOwner();

class TaskListNotifier extends StateNotifier<TaskList> 
{
  final FirebaseFirestore_Controller firestoreController = FirebaseFirestore_Controller();
  TaskListNotifier()
      : super((TaskList(list: taskListPassed)));


  void addTask(Task task) {
    final taskList = state.list;
    taskList.add(task);
    firestoreController.createToDo(task.title, task.description, task.dueDate, task.priority, task.ownerId);
    state = state;
  }

  void deleteTask(Task task) {
    final taskList = state.list;
    taskList.remove(task);
    firestoreController.deleteToDo(task.title);
    state = state;
  }

  void editTask(Task updatedTask) {
    /*????????
    final taskList = state.list;
    taskList.firstWhere((updatedTask) {
       
    });
    */
    state = state;
  }


  void loadTasksByOwner(String ownerId)
  {
    taskListPassed = firestoreController.fetchTasksByOwner(ownerId); 
    state = state;
  }


  }

  final taskListProvider =
    StateProvider<TaskListNotifier>((ref) {
  return TaskListNotifier();
});