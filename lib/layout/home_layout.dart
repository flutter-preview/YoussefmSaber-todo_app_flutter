import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app_flutter/modules/tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getName().then((value) {}).catchError((onError) {
            print(onError.toString());
          });
        },
        child: Icon(Icons.add),
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

  void createDatabase() async{
    var db = await openDatabase(
      'todo.db ',
      version: 1,
      onCreate: (database, version) {
        database.execute("Create Table tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, state TEXT)").then((value){
          print("Database Created");
        }).catchError(((error) {
          print("Error while creating the database: $error");
        }));
      },
      onOpen: (database) {
        print("Database opened");
      }
      );
  }

  void insertToDatabase() {

  }

  void getDataFromDatabase() {}
}
