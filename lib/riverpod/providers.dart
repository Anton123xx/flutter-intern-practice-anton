import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/task_model.dart'; // Import your Task model

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});
