// import 'package:flutter/material.dart';
//
// Container passwordTextfield({required String hintText, bool? isVisible=false, required TextEditingController controller}){
//   return  Container(
//     padding: EdgeInsets.symmetric(horizontal: 8),
//     height: 50,
//     decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(7),
//         color: Colors.grey.withOpacity(0.03)),
//     child: TextField(
//       controller: controller,
//       textInputAction: TextInputAction.done,
//       obscureText: isVisible? true : false,
//       decoration: InputDecoration(
//           suffixIcon: InkWell(
//             onTap: () {
//              isVisible = !isVisible;
//             },
//             child: Icon(isVisible
//                 ? Icons.visibility
//                 : Icons.visibility_off),
//           ),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: InputBorder.none),
//     ),
//   );
// }