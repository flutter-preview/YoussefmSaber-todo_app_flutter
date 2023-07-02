import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      onChanged: (s) {
        onChange!(s);
      },
      onTap: () {
        onTap!();
      },
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

Widget todoItem(Map task, context) => Dismissible(
      key: Key(task['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: task['id']);
        print(direction);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.lightGreen,
              child: Text(
                task['time'],
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'],
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    task['date'],
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(state: 'done', id: task['id']);
                },
                icon: const Icon(
                  Icons.done_outline_rounded,
                  color: Colors.greenAccent,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(state: 'archived', id: task['id']);
                },
                icon: const Icon(
                  Icons.archive_rounded,
                  color: Colors.blueGrey,
                ))
          ],
        ),
      ),
    );
