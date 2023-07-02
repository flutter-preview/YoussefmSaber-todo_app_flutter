import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/modules/cubit/cubit.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) => todoItem(tasks[index]),
            separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
            itemCount: tasks.length);
      },
      listener: (context, taskState) {},
    );
  }
}
