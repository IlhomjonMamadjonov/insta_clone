import 'package:flutter/material.dart';

Container textfield({required String hintText, bool? isHidden, required TextEditingController controller}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    height: 50,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(7),
        color: Colors.grey.withOpacity(0.03)),
    child: TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
          TextStyle(color: Colors.grey),
          border: InputBorder.none),
    ),
  );
}