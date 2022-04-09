import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/file_service.dart';
import 'package:instagram_clone/services/utils_service.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  File? image;
  UserModel? user;
  int countPosts = 0;
  List<Post> items = [];

  @override
  void onInit() {
    apiLoadUser();
    apiLoadPost();
    super.onInit();
  }

// for load user
  void apiLoadUser() async {
    isLoading = true;
    update();
    DataService.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(UserModel user) {
    this.user = user;
    isLoading = false;
    update();
  }

  // for edit user
  void _apiChangePhoto() {
    if (image == null) return;

    isLoading = true;
    update();
    FileService.uploadImage(image!, FileService.folderUserImg).then((imgUrl) {
      isLoading = false;
      user!.imgUrl = imgUrl;
      update();
      DataService.updateUser(user!);
    });
  }

  Future<void> getMyImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      _apiChangePhoto();
    }
    update();
    // return _image;
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      getMyImage(ImageSource.gallery);
                      Get.back();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    getMyImage(ImageSource.camera);
                    Get.back();
                  },
                ),
              ],
            ),
          );
        });
  }

  // for bring posts
  void apiLoadPost() {
    DataService.loadPosts().then((posts) => {_resLoadPost(posts)});
  }

  void _resLoadPost(List<Post> posts) {
    items = posts;
    countPosts = items.length;
    update();
  }

  logOut(BuildContext context) async {
    var result = await Utils.dialogCommon(
        context, "😟 😟 😟", "Do you really want to log out?", false);
    if (result) {
      AuthService.signOutUser();
    }
  }

  List<String> images = [
    "assets/images/profile_page_img/friends.jpg",
    "assets/images/profile_page_img/sport.jpg",
    "assets/images/profile_page_img/work.jpeg"
  ];

  List<String> titles = ["Friends", "Sport", "Work"];
}
