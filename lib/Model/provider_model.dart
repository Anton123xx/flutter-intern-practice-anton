import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/controllers/firebaseFirestore_controller.dart';
import 'package:task_manager/controllers/settings_controller.dart';
import '../utils/date_utils.dart' as date_utils;


class ProviderModel extends ChangeNotifier {
  //MANAGEMENT CONTROLLERS---------------------------------------

  late FirebaseFirestore_Controller firestore_controller = FirebaseFirestore_Controller();
  late Settings_Controller settings_controller = Settings_Controller();

  //UI CONST
  double width = 0;
  getWidth() => width;
  double height = 0;
  getHeight() => height;

  //EDIT TASK---------------------------------------
  TextEditingController titleControllerEditTask = TextEditingController();
  TextEditingController descriptionControllerEditTask = TextEditingController();
  getTitleControllerEditTask() => titleControllerEditTask;
  getDescriptionControllerEditTask() => descriptionControllerEditTask;


  //HOMESCREEN---------------------------------------
  //pour gerer date
  List<DateTime> currentMonthList = List.empty();
  getCurrentMonthList() => currentMonthList;

  DateTime currentDateTime = DateTime.now();
  getCurrentDateTime() => currentDateTime;
  updateCurrentDateTime(date) => currentDateTime = date;

  late ScrollController scrollController;
  getScrollController() => scrollController;
 

  //todo
  List todos = List.empty();

  String _title = "";
  getTitle() => _title;
  updateTitle(title) => _title = title;

  String _description = "";
  getDescription() => _description;
  updateDescription(description) => _description = description;

  DateTime _dueDate = DateTime.now();
  getDueDate() => _dueDate;
  updateDueDate(dueDate) => _dueDate = dueDate;

  static const List<String> priorities = ['Low', 'Medium', 'High'];
  getPriorityList() => priorities;

  String _priority = priorities[1];
  getPriority() => _priority;
  updatePriority(priority) => _priority = priority;

  String _owner = "";
  getOwner() => _owner;
  updateOwner(owner) => _owner = owner;

  //gerer current user
  User? _user;
  getUser() => _user;
  updateUser(user) => _user = user;




  ProviderModel() {
    ///---CONTROLLERS
    //firestore_controller = FirebaseFirestore_Controller();
    //settings_controller = Settings_Controller();



    //pour gerer date
    currentMonthList = date_utils.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController = ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);

    
    //gerer current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _owner = currentUser.uid.toString();
    } else {
      _owner = "null";
      print("OWNER PAS RECONNU");
    }

    //settings
    // await _loadDarkModePreference();
  }

/*
  void addTask(title, description, dueDate, priority, owner) {
    firestore_controller.createToDo(
        title, description, dueDate, priority, owner);
  }
*/
  void addTask() {
    firestore_controller.createToDo(_title, _description, _dueDate, _priority, _owner);
  }

  void deleteTask(String titleToDelete) {
    firestore_controller.deleteToDo(titleToDelete);
  }

  void updateTask(String? title, Map<String, dynamic> taskData, BuildContext context) {
    firestore_controller
        .getDocument(title)
        .set(taskData, SetOptions(merge: true))
        .then((value) => Navigator.pop(context))
        .onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }
  
  Stream<DocumentSnapshot<Object?>>? getDocumentSnapshot(String? title)
  {
         return firestore_controller.getCollectionSnapshots(title);
  }


   Stream<QuerySnapshot<Object?>>? getQuerySnapshotOwner(String owner)
  {
         return firestore_controller.getCollectionSnapshotsOwner(owner);
  }

}
