import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/utils/utils_service.dart';

class FeedWidget extends StatefulWidget {
  final Post post;
  final UserModel? user;
  final Function? function;
  final Function? load;

  const FeedWidget({required this.post, this.function, this.load, Key? key, this.user})
      : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  bool isLoading = false;

  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, true);
    if (mounted) {
      setState(() {
        isLoading = false;
        post.isLiked = true;
      });
    }
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.isLiked = false;
    });

    if (widget.function != null) {
      widget.function!();
    }
  }

  void updateLike() {
    if (widget.post.isLiked) {
      _apiPostUnLike(widget.post);
    } else {
      _apiPostLike(widget.post);
    }
  }

  void deletePost(Post post) async {
    bool result = await Utils.dialogCommon(
        context, "Instagram Clone", "Do yu want to remove this post?", false);

    if (result) {
      setState(() {
        isLoading = true;
      });

      await DataService.removePost(post);

      setState(() {
        isLoading = false;
      });

      if (widget.load != null) {
        widget.load!();
      }
    }
  }

  void _apiFollowUser(UserModel someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.followUser(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnFollowUser(UserModel someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.unFollowUser(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }

  void updateFollow(UserModel user) {
    if(user.followed) {
      _apiUnFollowUser(user);
    } else {
      _apiFollowUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity.compact,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image(
              image: AssetImage(widget.post.imageUser != null
                  ? widget.post.imageUser!
                  : "assets/images/default.jpg"),
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            widget.post.fullName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.black),
          ),
          subtitle: Text(
            widget.post.createdDate.substring(0, 16),
            style: TextStyle(color: Colors.black45),
          ),
          trailing: InkWell(
            onTap: () {
              widget.post.isMine
                  ? moreOptionMine(context)
                  : moreOptionNotMine(context,);
            },
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
        // #postImage
        InkWell(
          onDoubleTap: () {
            updateLike();
          },
          child: CachedNetworkImage(
            imageUrl: widget.post.postImage,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
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
                  InkWell(
                    onTap: () {
                      updateLike();
                    },
                    child: widget.post.isLiked
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
              InkWell(
                child: Icon(
                  Icons.bookmark_border,
                  color: Colors.black,
                  size: 30,
                ),
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
                  text: " ${widget.post.caption}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List moreText = [
    "Post to other apps",
    "Copy Link",
    "Share to...",
    "Archive",
    "Edit",
    "Hide like count",
    "Turn of commenting"
  ];

  void moreOptionMine(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            // <-- SEE HERE
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      itemCount: moreText.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Text(
                          "${moreText[index]}\n",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        );
                      }),
                  InkWell(
                      onTap: () {
                        deletePost(widget.post);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      )),
                ],
              ),
            ),
          );
        });
  }

  void moreOptionNotMine(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.only(top: 15, bottom: 5, right: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hide\n",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                InkWell(
                  onTap: (){
                    // updateFollow(widget.user!);
                  },
                    child: Text(
                  "Unfollow",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                )),
              ],
            ),
          );
        });
  }
}
