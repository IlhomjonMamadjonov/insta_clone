// #story builder
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/full_model.dart';
import 'package:instagram_clone/views/sized_box.dart';

Widget storyBuilder({required FullModel story}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sBoxHeight(20),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF8e44ad), width: 2)),
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image: AssetImage(story.userImage), fit: BoxFit.cover)),
          ),
        ),
        sBoxHeight(10),
        Text(
          moreText(story.userName),
          style:
          TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}