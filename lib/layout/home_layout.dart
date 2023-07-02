import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../modules/cubit/cubit.dart';
import '../modules/cubit/states.dart';
import '../shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertToDatabaseState) Navigator.pop(context);
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("Todo App"),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetFromDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetOpen) {
                  if (formKey.currentState?.validate() == true) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet((context) {
                    return Container(
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
                              prefix: Icons.title,
                            ),
                            SizedBox(height: 16),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.none,
                              validate: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Task should have a time';
                                }
                                return null;
                              },
                              label: 'Time',
                              prefix: Icons.watch_later_outlined,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  if (value != null) {
                                    timeController.text =
                                        value.format(context);
                                    print(value.format(context));
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 16),
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
                                  lastDate: DateTime.parse('2023-07-30'),
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text =
                                        DateFormat.yMMMMd().format(value);
                                    print(DateFormat.yMMMMd().format(value));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).closed.then((value) {
                    cubit.changeBottomSheetState(
                      isShown: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShown: true,
                    icon: Icons.save,
                  );
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              elevation: 15,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
