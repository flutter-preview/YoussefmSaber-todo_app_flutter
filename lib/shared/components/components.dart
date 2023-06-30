import 'package:flutter/material.dart';

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

Widget todoItem(Map task) => Container(
  padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.lightGreen,
            child: Text(
              task['time'],
              style: TextStyle(color: Colors.white,
              fontSize: 13),
            ),
          ),
          SizedBox(width: 8,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  task['title'],
                  style: TextStyle(
                      color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
              ),
              Text(
                task['date'],
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          )
        ],
      ),
    );
