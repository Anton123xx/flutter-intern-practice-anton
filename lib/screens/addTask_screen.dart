import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Model/task_model.dart';
import 'package:task_manager/screens/home_screen.dart';

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({super.key});

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? dueDateController;
  String priorityController = "Low";
  List<String> priorities = ['Low', 'Medium', 'High'];
  //late TextEditingController ownerIdController;
  bool isEditing = false;
  Task? taskToEdit = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(taskToEditProvider) != null) {
      taskToEdit = ref.watch(taskToEditProvider.notifier).state;
      isEditing = true;
    }

    titleController =
        TextEditingController(text: isEditing ? taskToEdit!.title : '');
    descriptionController =
        TextEditingController(text: isEditing ? taskToEdit!.description : '');
    //dueDateController = TextEditingController(text: isEditing ? taskToEdit!.dueDate.toString() : '');
    priorityController = isEditing ? taskToEdit!.priority : priorities[1];
    //ownerIdController = TextEditingController(text: isEditing ? taskToEdit!.ownerId : '');
    return Scaffold(
      appBar: AppBar(
        title: Text(taskToEdit == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: (isEditing
                              ? taskToEdit!.dueDate
                              : DateTime.now()),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (selectedDate != null) {
                        dueDateController = selectedDate;
                      }
                    },
                    child: const Text(
                      'Select Due Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (dueDateController != null)
                  Text('Due Date: ${dueDateController!.toLocal()}'),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              items: priorities.map((String p) {
                return DropdownMenuItem<String>(value: p, child: Text(p));
              }).toList(),
              value: (isEditing ? taskToEdit!.priority : priorities[1]),
              onChanged: (String? value) {
                priorityController = value!;
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
            ),
            // Other TextField widgets...
            ElevatedButton(
              onPressed: () {
                final task = Task(
                  id: taskToEdit?.id ??
                      UniqueKey()
                          .toString(), // Generate a new id if adding, use existing id if editing
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: isEditing ? taskToEdit!.dueDate : DateTime.now(),
                  priority: priorityController,
                  ownerId: ref
                      .read(currentUserProvider as ProviderListenable<String>),

                  ///????
                );
                if (isEditing) {
                  ref.read(taskListProvider).addTask(task);
                } else {
                  ref.read(taskListProvider).editTask(task);
                }
                Navigator.pop(context);
              },
              child: Text(isEditing == false ? 'Add Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
