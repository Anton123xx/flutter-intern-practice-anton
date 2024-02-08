import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Model/provider_model.dart';


class EditTaskScreen extends StatefulWidget {
  final String? title;
  const EditTaskScreen(Key? key, this.title) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  

  DateTime dueDate = DateTime.now();
  String? priority;
  List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderModel>(
        builder: (context, providerInstance, child) => Scaffold(
            appBar: AppBar(
                title: const Text('Edit Task'),
                backgroundColor: const Color.fromARGB(255, 129, 118, 226),
                centerTitle: true),
            body: StreamBuilder<DocumentSnapshot>(
              stream: providerInstance.getDocumentSnapshot(widget.title),
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
                          controller: providerInstance.getTitleControllerEditTask(), 
                          decoration: InputDecoration(
                              labelText:
                                  snapshot.data?['todoTitle'].toString()),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: providerInstance.getDescriptionControllerEditTask(), 
                          decoration: InputDecoration(
                              labelText: snapshot.data?['todoDesc'].toString()),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: snapshot.data?['dueDate'],
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100));

                                  if (selectedDate != null) {
                                      dueDate = selectedDate;
                                      //marche tu??

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
                              Text('Due Date: ${dueDate.toLocal()}'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          items: priorities.map((String p) {
                            return DropdownMenuItem<String>(
                                value: p, child: Text(p));
                          }).toList(),
                          value: snapshot.data?['priority'].toString(),
                          onChanged: (String? value) {
                            priority = value;
                            //providerInstance.updatePriority(priority);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> taskData = {
                                'todoTitle': providerInstance.getTitleControllerEditTask().text,
                                'todoDescription': providerInstance.getDescriptionControllerEditTask().text,
                                'dueDate': dueDate,
                                'priority': priority,
                                'owner': providerInstance.getOwner()
                              };

                              context
                                  .read<ProviderModel>()
                                  .updateTask(widget.title, taskData, context);
                            },
                            child: Text('Save Changes')),
                      ],
                    ),
                  );
                }
              },
            )));
  }
}
