import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/signIn_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  final String title ="";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List todos = List.empty();
  String title ="";
  String description ="";
  @override
  void initState(){
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  createToDo(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(title);
    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description
    };

    documentReference.set(todoList).whenComplete(() => print("Data stored succesfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(index.toString()), 
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(todos[index]),
                subtitle: Text("Description"),
                trailing: IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete),
                  onPressed: (){
                    setState(() {
                      todos.remove(index);
                    });
                  }, 
                  ),
              )
            ));
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add ToDo"),
                  content: Container(
                    width: 480,
                    height: 100,
                    child:Column(
                      children: [
                        TextField(
                          onChanged:(String value){
                            title = value;
                          },
                        ),
                        TextField(
                          onChanged: (String value){
                            description = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions:<Widget>[
                    TextButton(
                      onPressed: (){
                        setState(() {
                          //todos.add(title);
                          createToDo();
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add"))
                  ],     
                );
              });
          },
          child: const Icon(
            Icons.add,
            color:Colors.white,
          ),
        ),
      );
   }
}