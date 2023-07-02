import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../archived_tasks/archived_tasks_screen.dart';
import '../done_tasks/done_tasks_screen.dart';
import '../tasks/new_tasks_screen.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  int currentIndex = 0;

  late Database database;

  List<Map> tasks = [];

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
      getDataFromDatabase(database).then((value) {
        tasks = value;
        emit(AppGetFromDatabaseState());
      });
      print("Database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String time,
      required String date
      }) async {
    await database.transaction((txn) {
      return txn.rawInsert(
              "Insert Into tasks(title, date, time, state) values('$title', '$date', '$time', 'new')")
          .then((value) {
        print("$value inserted the data successfully");

        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database).then((value) {
          tasks = value;
          emit(AppGetFromDatabaseState());
        });
      }).catchError((onError) {
        print("error inserting the row: $onError");
      });
    }).catchError((error) {
      print("Error inserting data to database: $error");
    });
  }

  Future<List<Map>> getDataFromDatabase(Database database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon
}) {
    isBottomSheetOpen = isShown;
    fabIcon = icon;
    emit(AppChangeBottomNavState());
  }
}
