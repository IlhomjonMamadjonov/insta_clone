import 'package:flutter/material.dart';

SizedBox sBoxHeight(double number){
 return SizedBox(height: number,);
}

SizedBox sBoxWidth(double number){
  return SizedBox(width: number,);
}
// #more text
String moreText(String name) {
  return name.length < 11 ? name : name.substring(0, 6) + "...";
}