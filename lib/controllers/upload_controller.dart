import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/controllers/home_controller.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/file_service.dart';
import 'package:instagram_clone/services/utils_service.dart';

class UploadController extends GetxController {
  bool isLoading = false;
  File? image;
  bool isExpanded = false;
  TextEditingController captionController = TextEditingController();

  Future getMyImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
    update();
    return image;
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

  // for postUpload
  void uploadNewPost() {
    String caption = captionController.text.trim().toString();
    if (image == null) {
      Utils.fireSnackBar("Please upload at least one image!");
      return;
    }
    if (caption.isEmpty) {
      Utils.fireSnackBar("Please write something in caption!");
      return;
    }

    // Send post  to Server
    apiPostImage();
  }

  void apiPostImage() {
    isLoading = true;
    update();

    FileService.uploadImage(image!, FileService.folderPostImg)
        .then((imageUrl) => {
              resPostImage(imageUrl),
            });
  }

  void resPostImage(String imageUrl) {
    String caption = captionController.text.trim().toString();
    Post post = Post(postImage: imageUrl, caption: caption);
    apiStorePost(post);
  }

  void apiStorePost(Post post) async {
    // Post to posts folder
    Post posted = await DataService.storePost(post);
    // Post to feeds folder
    DataService.storeFeed(posted).then((value) => {
          moveToFeed(),
        });
  }

  void moveToFeed() {
    isLoading = false;
    Get.find<HomeController>().pageController.jumpTo(0);
    update();
  }
  void updateExpand(){
    isExpanded=!isExpanded;
    update();
  }
  void updateRemove(){
    image=null;
    isExpanded=false;
    update();
  }
}
