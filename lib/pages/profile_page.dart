import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/file_service.dart';
import 'package:instagram_clone/utils/utils_service.dart';

class ProfilePage extends StatefulWidget {
  static const String id = "/profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  File? image;
  UserModel? user;
  int countPosts = 0;
  List<Post> items=[];

  @override
  void initState() {
    super.initState();
    _apiLoadUser();
    _apiLoadPost();
  }

// for load user
  void _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(UserModel user) {
    setState(() {
      this.user = user;
      isLoading = false;
    });
  }

  // for edit user
  void _apiChangePhoto() {
    if (image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadImage(image!, FileService.folderUserImg).then((imgUrl) {
      setState(() {
        isLoading = false;
        user!.imgUrl = imgUrl;
      });
      DataService.updateUser(user!);
    });
  }
  // void _apiChangePhoto() {
  //    if (_image == null) return;
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //   FileService.uploadImage(_image!, FileService.folderUserImg)
  //       .then((value) => _apiUpdateUser(value));
  // }
  //
  // void _apiUpdateUser(String imgUrl) async {
  //   setState(() {
  //     isLoading = false;
  //     user!.imgUrl = imgUrl;
  //     print(user!.imgUrl);
  //   });
  //   await DataService.updateUser(user!);
  // }

  Future<void> getMyImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        _apiChangePhoto();
      }
    });
    // return _image;
  }

  void _showPicker(context) {
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
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    getMyImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  // for bring posts
  void _apiLoadPost() {
    DataService.loadPosts().then((posts) => {
      _resLoadPost(posts)
    });
  }

  void _resLoadPost(List<Post> posts) {
    if(mounted){
      setState(() {
        items = posts;
          countPosts = items.length;
      });
    }
  }
  _logOut()async{
    var result= await Utils.dialogCommon(context, "😟 😟 😟", "Do you really want to log out?", false);
    if(result){
      AuthService.signOutUser(context);
    }
  }
  List<String> images = [
    "assets/images/profile_page_img/friends.jpg",
    "assets/images/profile_page_img/sport.jpg",
    "assets/images/profile_page_img/work.jpeg"
  ];

  List<String> titles = ["Friends", "Sport", "Work"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        ///appbar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Icon(Icons.add_box_outlined),
            SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  _logOut();
                },
                icon: Icon(Icons.login_outlined)),
            SizedBox(
              width: 10,
            ),
          ],
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                ),
                Text(
                  user?.fullName == null ? "" : user!.fullName,
                  overflow: TextOverflow.visible,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        body: isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: GlowingOverscrollIndicator(
              color: const Color(0xffFAFAFA),
              axisDirection: AxisDirection.down,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///profile leading
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                //profile image
                                GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.purpleAccent,
                                            width: 2)),
                                    padding: EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(75),
                                      child: user?.imgUrl == null ||
                                              user!.imgUrl!.isEmpty
                                          ? const Image(
                                              image: AssetImage(
                                                  "assets/images/default.jpg"),
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : Image(
                                              image: NetworkImage(
                                                  user!.imgUrl!),
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                //post
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      items.length.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text("posts")
                                  ],
                                ),
                                //followers
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      user!.followersCount.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text("Followers")
                                  ],
                                ),
                                //following
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      user!.followingCount.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text("Following")
                                  ],
                                ),
                              ],
                            ),
                          ),

                          ///info
                          Container(
                              padding: EdgeInsets.only(left: 15, top: 5),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(user?.fullName== null ? "" : user!.fullName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(" . . ."),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text("TUIT 3/4 🎓"),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),

                          ///Edit Profile
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(6)),
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: MaterialButton(
                              onPressed: () {},
                              height: 30,
                              child: Text("Edit profile"),
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                          ),

                          ///Highlights
                          Container(
                            margin: EdgeInsets.only(
                                left: 11, right: 11, top: 11),
                            // height: 100,
                            height:
                                MediaQuery.of(context).size.height * 0.134,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ///only for plus button on highlight list
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(60),
                                      ),
                                      child: Container(
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.add)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "New",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                ///Story Builder
                                ListView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: images.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return _storyMaker(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]))
                  ];
                },

                /// grid and tagged buttons
                body: Column(
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black54,
                      indicatorColor: Colors.black,
                      indicatorWeight: 0.8,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.grid_on_sharp,
                            size: 25,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.person_pin_outlined,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              padding: EdgeInsets.only(top: 3),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (ctx, i) {
                                return buildGrid(i);
                              },
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                              ),
                            ),
                          ),
                          GridView.builder(
                            padding: EdgeInsets.only(top: 3),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (ctx, i) {
                              return buildGrid(i);
                            },
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container buildGrid(int i) {
    return Container(
      child:  CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: items[i].postImage,
        placeholder: (context, url) => const Image(
          image: AssetImage('assets/images/holder.png'),
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Container _storyMaker(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(images[index]), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            titles[index],
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
// #more text
// String _moreText(String name) {
//   return name.length < 11 ? name : name.substring(0, 6) + "...";
// }
