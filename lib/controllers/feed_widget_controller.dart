import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/utils_service.dart';

class FeedWidgetController extends GetxController {
  bool isLoading = false;

  void _apiPostLike(Post post) async {
    isLoading = true;
    update();
    await DataService.likePost(post, true);
    isLoading = false;
    post.isLiked = true;
    update();
  }

  void _apiPostUnLike(Post post, Function function) async {
    isLoading = true;
    update();
    await DataService.likePost(post, false);

    isLoading = false;
    post.isLiked = false;
    update();

    if (function != null) {
      function();
    }
  }

  void updateLike(Post post, Function function) {
    if (post.isLiked) {
      _apiPostUnLike(post, function);
    } else {
      _apiPostLike(post);
    }
  }

  void deletePost(BuildContext context,Post post, Function load) async {
    bool result = await Utils.dialogCommon(
        context, "Instagram Clone", "Do yu want to remove this post?", false);

    if (result) {
      isLoading = true;
      update();

      await DataService.removePost(post);

      isLoading = false;
      update();

      if (load != null) {
        load();
      }
    }
  }
}
