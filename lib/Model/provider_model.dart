import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/controllers/firebaseFirestore_controller.dart';
import 'package:task_manager/controllers/settings_controller.dart';
import '../utils/date_utils.dart' as date_utils;
import '../utils/colors_utils.dart' as color_utils;

class ProviderModel extends ChangeNotifier {
  //CONTROLLERS---------------------------------------

  FirebaseFirestore_Controller firestore_controller = new FirebaseFirestore_Controller();
  Settings_Controller settings_controller = new Settings_Controller();
 
  //HOMESCREEN---------------------------------------
  //pour gerer date
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  late ScrollController scrollController =
      ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);

  //todo
  List todos = List.empty();

  String _title = "";
  getTitle() => _title;
  updateTitle(title) => _title = title;

  String _description = "";
  getDescription() => _description;
  updateDescription(description) => _description = description;

  DateTime? _dueDate;
  getDueDate() => _dueDate;
  updateDueDate(dueDate) => _dueDate = dueDate;

  String _priority = "Medium";
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
  firestore_controller = new FirebaseFirestore_Controller();
  settings_controller = new Settings_Controller();
  
//pour gerer date
    currentMonthList = date_utils.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    //scrollController = ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);

//todo
    todos = ["Hello", "Hey There", currentDateTime, "Medium"];

//gerer current user
     User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _owner = currentUser!.uid.toString();
    } else {
      _owner = "null";
    }

    //settings
    // await _loadDarkModePreference();
  }

  ///methode
  ///
  ///
  ///
  ///
  

  void addTask(title, description, dueDate, priority, owner)
  {
    firestore_controller.createToDo(title, description, dueDate, priority, owner);
  }


  
  void deleteTask(String titleToDelete)
  {
firestore_controller.deleteToDo(titleToDelete);
  }






}
