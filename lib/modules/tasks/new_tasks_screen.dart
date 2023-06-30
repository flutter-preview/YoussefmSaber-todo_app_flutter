import 'package:flutter/material.dart';
import 'package:todo_app_flutter/shared/components/components.dart';
import '../../shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => todoItem(tasks[index]),
        separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.grey[300],
            ),
        itemCount: tasks.length);
  }
}
