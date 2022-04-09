import 'package:flutter/material.dart';

Container button({required dynamic title, required void Function() onPressed}){
  return Container(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    ),
  );
}