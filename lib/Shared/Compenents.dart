
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 42.h,

      child: MaterialButton(
        onPressed: (){
          function();
        },
        child: Padding(padding: EdgeInsets.symmetric(horizontal:16 ),
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white), // Set the border color to white

        borderRadius: BorderRadius.circular(

          radius,
        ),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  String? label,
  bool isPassword = false,
  bool isClickable = true,
  int? maxLength,
  double height = 56,
  double? width, // Added width parameter

  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  void Function()? onTap,
  String? Function(String?)? validator,
  IconData? prefix,
  IconData? suffix,
  void Function()? suffixPressed,
}) =>
    Container(
      width: width, // Set the width of the container
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        cursorColor: Colors.black,
        onFieldSubmitted: onSubmit,
        onChanged: onChanged,
        onTap: onTap,
        style: TextStyle(color: Colors.black),
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor:  Colors.white,
          labelText: label,
          prefixIcon: prefix != null
              ? Icon(
            prefix,
            color: Colors.black,
          )
              : null,
          suffixIcon: suffix != null
              ? IconButton(
            onPressed: suffixPressed,
            icon: Icon(
              suffix,
              color: Colors.black,
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          contentPadding: prefix != null ? null : EdgeInsets.only(left: 10.0.w),
          labelStyle: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
