import 'package:cloud_firestore/cloud_firestore.dart';


////comment faire?
///
///propriété : instance firebase
///-(pas a appeler plusieur fois instance)
///-(faut effacer qd on logout)
///
///

class FirebaseFirestore_Controller 
{
  final FirebaseFirestore instance = FirebaseFirestore.instance;


  CollectionReference<Map<String, dynamic>> getCollection()
  {
return instance.collection("MyTodos");
  }

  Stream<DocumentSnapshot<Object?>>? getCollectionSnapshots(String? title) {
    return getCollection().doc(title).snapshots();
  }

  Stream<QuerySnapshot<Object?>>? getCollectionSnapshotsOwner(String? owner) {
    return getCollection().where('owner', isEqualTo: owner).snapshots();
  }

  void deleteToDo(title) {
    getCollection().doc(title).delete();
  }

  void createToDo(String title, String description, DateTime? dueDate, String priority, String owner) {
    getCollection().doc(title);
    Map<String, dynamic> todoList = {
      "todoTitle": title,
      "todoDesc": description,
      "date": dueDate,
      "priority": priority,
      "owner": owner
    };

    getCollection().doc(title).set(todoList);
        
  }
   
   
  DocumentReference<Map<String, dynamic>> getDocument(String? title)
  {
    return getCollection().doc(title);
  }
 
}
