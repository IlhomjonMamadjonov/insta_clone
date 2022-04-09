import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/upload_controller.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/views/loading_widget.dart';
import 'package:instagram_clone/views/sized_box.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
        init: UploadController(),
        builder: (uploadController) {
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
                    onPressed: uploadController.uploadNewPost,
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                      size: 30,
                    )),
                sBoxWidth(5)
              ],
              // #cancel
              leading: IconButton(
                onPressed: () {
                  uploadController.image = null;
                  Get.off(HomePage.id);
                },
                icon: Icon(
                  CupertinoIcons.xmark,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: Get.height,
                    child: Column(
                      children: [
                        // #upload
                        GestureDetector(
                            onTap: () {
                              uploadController.showPicker(context);
                            },
                            child: Container(
                              height: Get.width - 60,
                              width: Get.width,
                              color: Colors.grey.shade200,
                              child: uploadController.image == null
                                  ? Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 65,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Stack(children: [
                                      Image.file(
                                        uploadController.image!,
                                        height: Get.height,
                                        width: Get.width,
                                        fit: !uploadController.isExpanded
                                            ? BoxFit.cover
                                            : null,
                                      ),

                                      // #expand and #delete button x
                                      Container(
                                        width: Get.width,
                                        color: Colors.black12,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // #expand
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade600,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      uploadController
                                                              .updateExpand();
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
                                                          uploadController
                                                              .updateRemove();
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .highlight_remove,
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
                            controller: uploadController.captionController,
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
                LoadingWidget(
                  isLoading: uploadController.isLoading,
                )
              ],
            ),
          );
        });
  }
}
