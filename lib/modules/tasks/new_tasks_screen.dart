import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, taskState) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return ConditionalBuilder(
            condition: AppCubit.get(context).newTasks.length > 0,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                    todoItem(tasks[index], context),
                separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                itemCount: tasks.length),
            fallback: (context) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 32,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "There is no Tasks added.\n Please add some tasks",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
      },
    );
  }
}
