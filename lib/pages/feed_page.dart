import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/feed_controller.dart';
import 'package:instagram_clone/models/story_list.dart';
import 'package:instagram_clone/pages/chat_page.dart';
import 'package:instagram_clone/views/feed_widget.dart';
import 'package:instagram_clone/views/loading_widget.dart';
import 'package:instagram_clone/views/story_builder.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(
      init: FeedController(),
      builder: (feedController) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Instagram",
              style: TextStyle(
                  fontFamily: "Billabong",
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            actions: [
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(ChatPage.id);
                    },
                    icon: Icon(
                      FontAwesomeIcons.facebookMessenger,
                      color: Colors.black87,
                    )),
              )
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // #story
                    SizedBox(
                      height: Get.height / 6.2,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: StoryList().elements.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return storyBuilder(
                                story: StoryList().elements[index]);
                          }),
                    ),
                    Divider(
                      color: Colors.black12,
                      thickness: 1,
                    ),
                    ListView.builder(
                        itemCount: feedController.items.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return FeedWidget(
                            post: feedController.items[index],
                            load: feedController.apiLoadFeeds,
                          );
                        })
                  ],
                ),
              ),
              LoadingWidget(
                isLoading: feedController.isLoading,
              )
            ],
          ),
        );
      },
    );
  }
}
