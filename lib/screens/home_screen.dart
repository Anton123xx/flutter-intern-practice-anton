import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Model/provider_model.dart';
import '../utils/date_utils.dart' as date_utils;
import '../utils/colors_utils.dart' as color_utils;
import 'editTask_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final String title = "";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 @override
  void initState() {
    
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ///pas utiliser??
    //double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;

    return Consumer<ProviderModel>(
        builder: (context, providerInstance, child) => Scaffold(
              appBar: AppBar(
                title: const Text('TODO'),
                backgroundColor: Color.fromARGB(255, 129, 118, 226),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.pushNamed(context, '/accountInfo_screen');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings_screen');
                    },
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  backgroundView(),
                  topView(providerInstance),
                  toDoListView(providerInstance)
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text("Add To Do"),
                          content: Container(
                            width: 480,
                            height: 144,
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (String value) {
                                    //title = value;
                                    providerInstance.updateTitle(value);
                                  },
                                ),
                                TextField(
                                  onChanged: (String value) {
                                    //description = value;
                                    providerInstance.updateDescription(value);
                                  },
                                ),
                                DropdownButtonFormField<String>(
                                  items: providerInstance
                                      .getPriorityList()
                                      .map((String p) {
                                    return DropdownMenuItem<String>(
                                        value: p, child: Text(p));
                                  }).toList(),
                                  value: providerInstance.getPriorityList()[1],

                                  ///par default?
                                  onChanged: (String? value) {
                                    providerInstance.updatePriority(value);
                                  },
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  //context.read<ProviderModel>().addTask(title,description, dueDate, priority, owner);
                                  context.read<ProviderModel>().addTask();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Add"))
                          ],
                        );
                      });
                },
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 220, 39, 39),
                ),
              ),
            ));
  }

//UI
  Widget backgroundView() {
    return Container(
      decoration: BoxDecoration(
        color: color_utils.hexStringToColor("#EEE451"),
        image: DecorationImage(
          image: const AssetImage("assets/images/background_TODO.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.saturation),
        ),
      ),
    );
  }

  Widget titleView(ProviderModel providerInstance) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        date_utils.DateUtils
                .months[providerInstance.getCurrentDateTime().month - 1] +
            ' ' +
            providerInstance.getCurrentDateTime().year.toString(),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget horizontalCapsuleListView(ProviderModel providerInstance) {
    return Container(
      width: providerInstance.getWidth(),
      height: 150,
      child: ListView.builder(
        controller: providerInstance.getScrollController(),
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: providerInstance.getCurrentMonthList().length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index, providerInstance);
        },
      ),
    );
  }

  Widget capsuleView(int index, ProviderModel providerInstance) {
    ///variable locale pour par appeler provider tout le temp?
    ///
    DateTime currentDateTime = providerInstance.getCurrentDateTime();
    List<DateTime> currentMonthList = providerInstance.getCurrentMonthList();
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            providerInstance.updateCurrentDateTime(currentMonthList[index]);
          },
          child: Container(
            width: 80,
            height: 140,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (currentMonthList[index].day != currentDateTime.day)
                        ? [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.6)
                          ]
                        : [
                            color_utils.hexStringToColor("ED6184"),
                            color_utils.hexStringToColor("EF315B"),
                            color_utils.hexStringToColor("E2042D")
                          ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: Colors.black12,
                  )
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? color_utils.hexStringToColor("465876")
                                : Colors.white),
                  ),
                  Text(
                    date_utils.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? color_utils.hexStringToColor("465876")
                                : Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget topView(ProviderModel providerInstance) {
    return Container(
      height: providerInstance.getHeight() * 0.35,
      width: providerInstance.getWidth(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              color_utils.hexStringToColor("488BC8").withOpacity(0.7),
              color_utils.hexStringToColor("488BC8").withOpacity(0.5),
              color_utils.hexStringToColor("488BC8").withOpacity(0.3)
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: const [
          BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(4, 4),
              spreadRadius: 2)
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(providerInstance),
            horizontalCapsuleListView(providerInstance),
          ]),
    );
  }

  Widget toDoListView(ProviderModel providerInstance) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            10, providerInstance.getHeight() * 0.38, 10, 10),
        width: providerInstance.getWidth(),
        height: providerInstance.getHeight() * 0.60,
        child: StreamBuilder<QuerySnapshot>(
            stream: providerInstance
                .getQuerySnapshotOwner(providerInstance.getOwner()),
            //fetchAndFilterCollection(), //devrais filter les task pour juste afficher les bonne
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot<Object?>? documentSnapshot =
                          snapshot.data?.docs[index];
                      return Dismissible(
                          key: Key(index.toString()),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text((documentSnapshot != null)
                                  ? (documentSnapshot["todoTitle"])
                                  : ""),
                              subtitle: Text((documentSnapshot != null)
                                  ? ((documentSnapshot["todoDesc"] != null)
                                      ? documentSnapshot["todoDesc"]
                                      : "")
                                  : ""),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTaskScreen(
                                          Key(index.toString()),
                                          (documentSnapshot != null)
                                              ? (documentSnapshot["todoTitle"])
                                              : ""))),
                              trailing: IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  //stu le bon context???
                                  context.read<ProviderModel>().deleteTask(
                                      (documentSnapshot != null)
                                          ? (documentSnapshot["todoTitle"])
                                          : "");
                                },
                              ),
                            ),
                          ));
                    });
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
                ),
              );
            }));
  }


}









  /*
  @override
  Widget build(BuildContext context) {
    ///pas utiliser??
    //double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;

    return Consumer<ProviderModel>(
        builder: (context, providerInstance, child) => Scaffold(
              appBar: AppBar(
                title: const Text('TODO'),
                backgroundColor: Color.fromARGB(255, 129, 118, 226),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.pushNamed(context, '/accountInfo_screen');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings_screen');
                    },
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  backgroundView(),
                  topView(providerInstance),
                  toDoListView(providerInstance)
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text("Add To Do"),
                          content: Container(
                            width: 480,
                            height: 144,
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (String value) {
                                    //title = value;
                                    providerInstance.updateTitle(title);
                                  },
                                ),
                                TextField(
                                  onChanged: (String value) {
                                    //description = value;
                                    providerInstance.updateDescription(value);
                                  },
                                ),
                                DropdownButtonFormField<String>(
                                  items: providerInstance
                                      .getPriorityList()
                                      .map((String p) {
                                    return DropdownMenuItem<String>(
                                        value: p, child: Text(p));
                                  }).toList(),
                                  value: providerInstance.getPriorityList()[1],

                                  ///par default?
                                  onChanged: (String? value) {
                                    providerInstance.updatePriority(value);
                                  },
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  //context.read<ProviderModel>().addTask(title,description, dueDate, priority, owner);
                                  context.read<ProviderModel>().addTask();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Add"))
                          ],
                        );
                      });
                },
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 220, 39, 39),
                ),
              ),
            ));
  }

//UI
  Widget backgroundView() {
    return Container(
      decoration: BoxDecoration(
        color: color_utils.hexStringToColor("#EEE451"),
        image: DecorationImage(
          image: const AssetImage("assets/images/background_TODO.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.saturation),
        ),
      ),
    );
  }

  Widget titleView(ProviderModel providerInstance) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        date_utils.DateUtils
                .months[providerInstance.getCurrentDateTime().month - 1] +
            ' ' +
            providerInstance.getCurrentDateTime().year.toString(),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget horizontalCapsuleListView(ProviderModel providerInstance) {
    return Container(
      width: providerInstance.getWidth(),
      height: 150,
      child: ListView.builder(
        controller: providerInstance.getScrollController(),
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: providerInstance.getCurrentMonthList().length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index, providerInstance);
        },
      ),
    );
  }

  Widget capsuleView(int index, ProviderModel providerInstance) {
    ///variable locale pour par appeler provider tout le temp?
    ///
    DateTime currentDateTime = providerInstance.getCurrentDateTime();
    List<DateTime> currentMonthList = providerInstance.getCurrentMonthList();
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            providerInstance.updateCurrentDateTime(currentMonthList[index]);
          },
          child: Container(
            width: 80,
            height: 140,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (currentMonthList[index].day != currentDateTime.day)
                        ? [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.6)
                          ]
                        : [
                            color_utils.hexStringToColor("ED6184"),
                            color_utils.hexStringToColor("EF315B"),
                            color_utils.hexStringToColor("E2042D")
                          ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: Colors.black12,
                  )
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? color_utils.hexStringToColor("465876")
                                : Colors.white),
                  ),
                  Text(
                    date_utils.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? color_utils.hexStringToColor("465876")
                                : Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget topView(ProviderModel providerInstance) {
    return Container(
      height: providerInstance.getHeight() * 0.35,
      width: providerInstance.getWidth(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              color_utils.hexStringToColor("488BC8").withOpacity(0.7),
              color_utils.hexStringToColor("488BC8").withOpacity(0.5),
              color_utils.hexStringToColor("488BC8").withOpacity(0.3)
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: const [
          BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(4, 4),
              spreadRadius: 2)
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(providerInstance),
            horizontalCapsuleListView(providerInstance),
          ]),
    );
  }

  Widget toDoListView(ProviderModel providerInstance) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            10, providerInstance.getHeight() * 0.38, 10, 10),
        width: providerInstance.getWidth(),
        height: providerInstance.getHeight() * 0.60,
        child: StreamBuilder<QuerySnapshot>(
            stream: providerInstance
                .getQuerySnapshotOwner(providerInstance.getOwner()),
            //fetchAndFilterCollection(), //devrais filter les task pour juste afficher les bonne
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot<Object?>? documentSnapshot =
                          snapshot.data?.docs[index];
                      return Dismissible(
                          key: Key(index.toString()),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text((documentSnapshot != null)
                                  ? (documentSnapshot["todoTitle"])
                                  : ""),
                              subtitle: Text((documentSnapshot != null)
                                  ? ((documentSnapshot["todoDesc"] != null)
                                      ? documentSnapshot["todoDesc"]
                                      : "")
                                  : ""),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTaskScreen(
                                          Key(index.toString()),
                                          (documentSnapshot != null)
                                              ? (documentSnapshot["todoTitle"])
                                              : ""))),
                              trailing: IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  //stu le bon context???
                                  context.read<ProviderModel>().deleteTask(
                                      (documentSnapshot != null)
                                          ? (documentSnapshot["todoTitle"])
                                          : "");
                                },
                              ),
                            ),
                          ));
                    });
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
                ),
              );
            }));
  }
  */

