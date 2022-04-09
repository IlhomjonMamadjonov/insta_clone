import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/data_service.dart';

class SearchController extends GetxController {
  TextEditingController controller = TextEditingController();
  List<UserModel> user = [];
  bool isLoading = false;

  @override
  void onInit() {
    apiSearchUsers("");
    super.onInit();
  }

  void apiSearchUsers(String keyword) {
    isLoading = true;
    update();
    DataService.searchUsers(keyword).then((users) => resSearchUser(users));
  }

  void resSearchUser(List<UserModel> users) {
    isLoading = false;
    user = users;
    update();
  }

  void apiFollowUser(UserModel someone) async {
    isLoading = true;
    update();
    await DataService.followUser(someone);

    someone.followed = true;
    isLoading = false;
    update();
    DataService.storePostsToMyFeed(someone);
  }

  void apiUnFollowUser(UserModel someone) async {
    isLoading = true;
    update();
    await DataService.unFollowUser(someone);

    someone.followed = false;
    isLoading = false;
    update();
    DataService.removePostsFromMyFeed(someone);
  }

  void updateFollow(UserModel user) {
    if (user.followed) {
      apiUnFollowUser(user);
    } else {
      apiFollowUser(user);
    }
  }
}
