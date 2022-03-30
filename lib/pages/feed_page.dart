import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/full_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/story_list.dart';
import 'package:instagram_clone/pages/chat_page.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/utils/feed_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiLoadFeeds() async {
    setState(() {
      isLoading = true;
    });

    DataService.loadFeeds().then((posts) => {
      _resLoadFeeds(posts)
    });
  }

  void _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  // _actionRemovePost(Post post) async{
  //   // var result = await Utils.dialogCommon(context, "Insta Clone", "Do you want to remove this post?", false);
  //   if(result != null && result){
  //     setState(() {
  //       isLoading = true;
  //     });
  //     DataService.removePost(post).then((value) => {
  //       _apiLoadFeeds(),
  //     });
  //   }
  // }1

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Instagram",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 35, color: Colors.black,fontWeight: FontWeight.w500),
        ),
        actions: [
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatPage.id);
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
            child: Column(
              children: [
                // #story
                SizedBox(
                  height: MediaQuery.of(context).size.height /
                      7, // height: 120,
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
                    itemCount: items.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FeedWidget(
                        post: items[index],
                        load: _apiLoadFeeds,
                      );
                    })
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }



  // #story builder
  Widget storyBuilder({required FullModel story}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
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
          const SizedBox(
            height: 10,
          ),
          Container(
              child: Text(
            _moreText(story.userName),
            style:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
          ))
        ],
      ),
    );
    ;
  }

  // #more text
  String _moreText(String name) {
    return name.length < 11 ? name : name.substring(0, 6) + "...";
  }
}
/*
 // #postBuilder
  Widget postBuilder(Post post) {
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image(
              image: AssetImage(post.imageUser != null
                  ? post.imageUser!
                  : "assets/images/default.jpg"),
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            post.fullName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.black),
          ),
          subtitle: Text(
            post.createdDate.substring(0, 16),
            style: TextStyle(color: Colors.black45),
          ),
          trailing: InkWell(
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
        // #postImage
        CachedNetworkImage(
          imageUrl: post.postImage,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        // #Row action buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // like
                  IconButton(
                      onPressed: () {
                        if (!post.isLiked) {
                          _apiPostLike(post);
                        } else {
                          _apiPostUnLike(post);
                        }
                      },
          icon: post.isLiked
              ? Icon(
            Icons.favorite,
            color: Colors.red,
            size: 30,
          )
              : Icon(
            Icons.favorite_border,
            size: 30,
          ),
        ),
                  SizedBox(width: 10),
                  //comment
                  Icon(FontAwesomeIcons.comment),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.paperPlane),
                ],
              ),
              Icon(
                Icons.bookmark_border,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.visible,
            text: TextSpan(
              children: [
                TextSpan(
                  text: " ${post.caption}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
 */
