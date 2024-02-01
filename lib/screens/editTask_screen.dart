import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {
  final String? title;
  const EditTaskScreen(Key? key, this.title) :super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? dueDate;
  String? priority;
  List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Edit Task'),
            backgroundColor: const Color.fromARGB(255, 129, 118, 226),
            centerTitle: true),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("MyTodos")
              .doc(widget.title)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
                return const Text("Something went wrong");
            } else {
             return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: snapshot.data?['todoTitle'].toString()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: snapshot.data?['todoDesc'].toString()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: snapshot.data?['date'],
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));

                              if (selectedDate != null) {
                                setState(() {
                                  dueDate = selectedDate;
                                });
                              }
                            },
                            child: const Text(
                              'Select Due Date',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (dueDate != null)
                          Text('Due Date: ${dueDate!.toLocal()}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    /*
                    DropdownButtonFormField<String>(
                      items: priorities.map((String p) {
                        return DropdownMenuItem<String>(
                          value: p,
                          child: Text(p)       
                        );
                      }).toList(),
                      value: snapshot.data?['priority'].toString(),
                      onChanged: (String? value) {
                        setState(() {
                          priority = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                    ),
                    const SizedBox(height: 24),
                    */
                    ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> taskData = {
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'dueDate': dueDate,
                            'priority': priority,
                          };
                          // Update or add task data to Firestore
                          await FirebaseFirestore.instance
                              .collection('MyTodos')
                              .doc(widget.title)
                              .set(taskData, SetOptions(merge: true))
                              .then((value) => Navigator.pop(context))
                              .onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        },
                        child: Text('Save Changes')),
                  ],
                ),
              );
            }
          },
        ));
  }
}
