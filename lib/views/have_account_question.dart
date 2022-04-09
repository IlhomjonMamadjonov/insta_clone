import 'package:flutter/material.dart';

Row haveAccount({required String question,required String option}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        question,
        style: TextStyle(color: Colors.grey),
      ),
      Text(
        option,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    ],
  );
}