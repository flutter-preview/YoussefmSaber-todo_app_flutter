import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app_flutter/modules/tasks/new_tasks_screen.dart';

import '../shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  late Database db;

  bool isBottomSheetOpen = false;

  IconData fabIcon = Icons.edit;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  @override
  void initState() {
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetOpen) {
            insertToDatabase(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text)
                .then((value) {
              if (formKey.currentState?.validate() == true) {
                setState(() {
                  fabIcon = Icons.edit;
                });
                Navigator.pop(context);
                isBottomSheetOpen = false;
              }
            }).catchError((error) {
              print("Error adding the data to the database: error");
            });
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                    elevation: 15,
                    (context) => Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Task should have a title';
                                      }
                                      return null;
                                    },
                                    label: 'Title',
                                    prefix: Icons.title),
                                const SizedBox(
                                  height: 16,
                                ),
                                defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.none,
                                    validate: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Task should have a title';
                                      }
                                      return null;
                                    },
                                    label: 'Time',
                                    prefix: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                        print(value.format(context));
                                      });
                                    }),
                                const SizedBox(
                                  height: 16,
                                ),
                                defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.none,
                                    validate: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Task should have a date';
                                      }
                                      return null;
                                    },
                                    label: 'Date',
                                    prefix: Icons.calendar_today_outlined,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2023-07-30'))
                                          .then((value) {
                                        if (value != null) {
                                          dateController.text =
                                              DateFormat.yMMMMd().format(value);
                                          print(DateFormat.yMMMMd()
                                              .format(value));
                                        }
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ))
                .closed
                .then((value) {
              isBottomSheetOpen = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetOpen = true;
            setState(() {
              fabIcon = Icons.save;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        elevation: 15,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done_all), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archive'),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'Pixelase';
  }

  void createDatabase() async {
    db = await openDatabase('todo.db ', version: 1,
        onCreate: (database, version) {
      database
          .execute(
              "Create Table tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, state TEXT)")
          .then((value) {
        print("Database Created");
      }).catchError(((error) {
        print("Error while creating the database: $error");
      }));
    }, onOpen: (database) {
      print("Database opened");
    });
  }

  Future insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    return await db.transaction((txn) {
      return txn
          .rawInsert(
              "Insert Into tasks(title, date, time, state) values('$title', '$date', '$time', 'new')")
          .then((value) {
        print("$value inserted the data successfully");
      }).catchError((onError) {
        print("error inserting the row: $onError");
      });
    }).catchError((error) {
      print("Error inserting data to database: $error");
    });
  }

  void getDataFromDatabase() {}
}
