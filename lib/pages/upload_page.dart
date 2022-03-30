import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/file_service.dart';
import 'package:instagram_clone/utils/utils_service.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
 bool isLoading = false;
  File? image;
  bool isExpanded = false;
  TextEditingController captionController = TextEditingController();

  Future getMyImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    });
    return image;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child:  Wrap(
                children: <Widget>[
                   ListTile(
                      leading:  Icon(Icons.photo_library),
                      title:  Text('Gallery'),
                      onTap: () {
                        getMyImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                   ListTile(
                    leading:  Icon(Icons.photo_camera),
                    title:  Text('Camera'),
                    onTap: () {
                      getMyImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // for postUpload
  void _uploadNewPost() {
    String caption = captionController.text.trim().toString();
    if(image == null) {
      Utils.fireSnackBar("Please upload at least one image!", context);
      return;
    }
    if(caption.isEmpty) {
      Utils.fireSnackBar("Please write something in caption!", context);
      return;
    }

    // Send post  to Server
    _apiPostImage();
  }

  void _apiPostImage() {
    setState(() {
      isLoading = true;
    });

    FileService.uploadImage(image!, FileService.folderPostImg).then((imageUrl) => {
      _resPostImage(imageUrl),
    });
  }

  void _resPostImage(String imageUrl) {
    String caption = captionController.text.trim().toString();
    Post post = Post(postImage: imageUrl, caption: caption);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    // Post to posts folder
    Post posted = await DataService.storePost(post);
    // Post to feeds folder
    DataService.storeFeed(posted).then((value) => {
      _moveToFeed(),
    });
  }

  void _moveToFeed() {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "New Post",
          style: TextStyle(fontSize: 21, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: _uploadNewPost,
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.blue,
                size: 30,
              )),
          SizedBox(
            width: 5,
          )
        ],
        // #cancel
        leading: IconButton(
          onPressed: () {
            setState(() {
              image = null;
            });
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
          icon: Icon(
            CupertinoIcons.xmark,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // #upload
                GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width - 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade200,
                      child: image == null
                          ? Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 65,
                          color: Colors.grey,
                        ),
                      )
                          : Stack(children: [
                        Image.file(
                          image!,
                          height: double.infinity,
                          width: double.infinity,
                          fit: !isExpanded ? BoxFit.cover : null,
                        ),
                        // #expand and #delete button x
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // #expand
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade600,
                                        borderRadius:
                                        BorderRadius.circular(60)),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.expand,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // #delete img
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              image = null;
                                              isExpanded=false;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.highlight_remove,
                                            size: 33,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                    )),
                // #caption
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    focusNode: FocusNode(),
                    controller: captionController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Caption",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    minLines: 1,
                    maxLines: 8,
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading?Center(
          child: CircularProgressIndicator(),
        ):SizedBox.shrink()
      ],),
    );
  }
}
