import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../archived_tasks/archived_tasks_screen.dart';
import '../done_tasks/done_tasks_screen.dart';
import '../tasks/new_tasks_screen.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }
}
