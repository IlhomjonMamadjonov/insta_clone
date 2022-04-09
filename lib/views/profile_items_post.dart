import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/controllers/profile_controller.dart';

Container buildGrid(ProfileController profileController,int i) {
  return Container(
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: profileController.items[i].postImage,
      placeholder: (context, url) => const Image(
        image: AssetImage('assets/images/holder.png'),
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}

Container storyMaker(ProfileController profileController,int index) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Container(
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileController.images[index]), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          profileController.titles[index],
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}