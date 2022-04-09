import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/like_controller.dart';
import 'package:instagram_clone/views/feed_widget.dart';
import 'package:instagram_clone/views/loading_widget.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);
  static const String id = "likes_page";

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LikeController>(
        init: LikeController(),
        builder: (likeController) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Activity",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                likeController.items.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: likeController.items.length,
                        itemBuilder: (context, index) {
                          return FeedWidget(
                            post: likeController.items[index],
                            function: likeController.apiLoadLikes,
                            load: likeController.apiLoadLikes,
                          );
                        })
                    : Center(
                        child: Text(
                          "No liked posts yet.",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                LoadingWidget(
                  isLoading: likeController.isLoading,
                )
              ],
            ),
          );
        });
  }
}
