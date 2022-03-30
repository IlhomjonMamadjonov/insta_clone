import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/utils/utils_service.dart';


class FeedWidget extends StatefulWidget {
  final Post post;
  final Function? function;
  final Function? load;

  const FeedWidget({required this.post, this.function, this.load, Key? key}) : super(key: key);

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
    if(mounted) {
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

    if(widget.function != null) {
      widget.function!();
    }
  }

  void updateLike() {
    if(widget.post.isLiked) {
      _apiPostUnLike(widget.post);
    } else {
      _apiPostLike(widget.post);
    }
  }

  void deletePost(Post post) async {
    bool result = await Utils.dialogCommon(context, "Instagram Clone", "Do yu want to remove this post?", false);

    if(result) {
      setState(() {
        isLoading = true;
      });

      await DataService.removePost(post);

      setState(() {
        isLoading = false;
      });

      if(widget.load != null) {
        widget.load!();
      }
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
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
        // #postImage
        InkWell(
          onDoubleTap: (){updateLike();},
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
                    onTap: (){updateLike();},
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
}