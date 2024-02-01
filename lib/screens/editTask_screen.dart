import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;
  String? priority;
  List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        backgroundColor: Color.fromARGB(255, 129, 118, 226),
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          dueDate = selectedDate;
                        });
                      }
                    },
                    child: Text(
                      'Select Due Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                if (dueDate != null) Text('Due Date: ${dueDate!.toLocal()}'),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: priority,
              onChanged: (String? value) {
                setState(() {
                  priority = value;
                });
              },
              items: priorities.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Priority',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save changes logic goes here
                String title = titleController.text;
                String description = descriptionController.text;

                // Perform actions with updated data (title, description, dueDate, priority)

                // For simplicity, just print the values
                print('Title: $title');
                print('Description: $description');
                print('Due Date: $dueDate');
                print('Priority: $priority');

                // You can add logic to update the task data in your database or state management system

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
