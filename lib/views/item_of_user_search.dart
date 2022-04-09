import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/controllers/search_controller.dart';
import 'package:instagram_clone/models/user_model.dart';

Widget itemOfUser(SearchController searchController, UserModel user) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>OthersProfile(uid: user.uid)));
      },
      leading: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.purpleAccent, width: 2)),
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: user.imgUrl != null
              ? CachedNetworkImage(
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            imageUrl: user.imgUrl!,
            placeholder: (context, url) => const Image(
                image: AssetImage("assets/images/default.jpg")),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
              : const Image(
            image: AssetImage("assets/images/default.jpg"),
            height: 40,
            width: 40,
          ),
        ),
      ),
      title: Text(
        user.fullName,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user.email,
          style: TextStyle(
            color: Colors.black54,
          )),
      trailing: Container(
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: MaterialButton(
          onPressed: () => searchController.updateFollow(user),
          child: Text(
            user.followed ? "Following" : "Follow",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ),
    ),
  );
}