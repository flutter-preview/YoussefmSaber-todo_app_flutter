import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/tasks/new_tasks_screen.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  int currentIndex = 0;

  late Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  bool isBottomSheetOpen = false;

  IconData fabIcon = Icons.edit;

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  void createDatabase() {
    openDatabase('todo.db ', version: 1, onCreate: (database, version) {
      database
          .execute(
              "Create Table tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, state TEXT)")
          .then((value) {
        print("Database Created");
      }).catchError(((error) {
        print("Error while creating the database: $error");
      }));
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("Database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              "Insert Into tasks(title, date, time, state) values('$title', '$date', '$time', 'new')")
          .then((value) {
        print("$value inserted the data successfully");

        emit(AppInsertToDatabaseState());

        getDataFromDatabase(database);
      }).catchError((onError) {
        print("error inserting the row: $onError");
      });
    }).catchError((error) {
      print("Error inserting data to database: $error");
    });
  }

  getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetFromDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        switch (element['state']) {
          case 'new':
            newTasks.add(element);
            break;
          case 'done':
            doneTasks.add(element);
            break;
          case 'archived':
            archivedTasks.add(element);
            break;
        }
        print(element['state']);
      }
      emit(AppGetFromDatabaseState());
    });
  }

  void updateData({required String state, required int id}) {
    database.rawUpdate(
        'Update tasks SET state = ? Where id = ?', [state, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateToDatabaseState());
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('Delete From tasks where id = ?', [id]);
    getDataFromDatabase(database);
    emit(AppDeleteFromDatabase());
  }

  void changeBottomSheetState({required bool isShown, required IconData icon}) {
    isBottomSheetOpen = isShown;
    fabIcon = icon;
    emit(AppChangeBottomNavState());
  }
}
