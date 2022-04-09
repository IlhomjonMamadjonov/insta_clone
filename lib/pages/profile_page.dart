import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/profile_controller.dart';
import 'package:instagram_clone/views/loading_widget.dart';
import 'package:instagram_clone/views/profile_items_post.dart';
import 'package:instagram_clone/views/sized_box.dart';

class ProfilePage extends StatefulWidget {
  static const String id = "/profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (profileController) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  Icon(Icons.add_box_outlined),
                  sBoxWidth(5),
                  IconButton(
                      onPressed: () {
                        profileController.logOut(context);
                      },
                      icon: Icon(Icons.login_outlined)),
                  sBoxWidth(10),
                ],
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                title: SizedBox(
                  width: Get.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                      ),
                      Text(
                        profileController.user?.email == null
                            ? ""
                            : profileController.user!.fullName,
                        overflow: TextOverflow.visible,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
              ),
              body: profileController.isLoading
                  ? LoadingWidget(
                      isLoading: profileController.isLoading,
                    )
                  : ScrollConfiguration(
                      behavior: const ScrollBehavior(),
                      child: GlowingOverscrollIndicator(
                          color: const Color(0xffFAFAFA),
                          axisDirection: AxisDirection.down,
                          child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ///profile leading
                                      Container(
                                        height: 100,
                                        width: Get.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            //profile image
                                            GestureDetector(
                                              onTap: () {
                                                profileController
                                                    .showPicker(context);
                                              },
                                              child: Container(
                                                height: 75,
                                                width: 75,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color:
                                                            Colors.purpleAccent,
                                                        width: 2)),
                                                padding: EdgeInsets.all(2),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(75),
                                                  child: profileController.user
                                                                  ?.imgUrl ==
                                                              null ||
                                                          profileController
                                                              .user!
                                                              .imgUrl!
                                                              .isEmpty
                                                      ? const Image(
                                                          image: AssetImage(
                                                              "assets/images/default.jpg"),
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image(
                                                          image: NetworkImage(
                                                              profileController
                                                                  .user!
                                                                  .imgUrl!),
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
                                                  profileController.items.length
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  profileController
                                                      .user!.followersCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  profileController
                                                      .user!.followingCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          padding:
                                              EdgeInsets.only(left: 15, top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  profileController
                                                              .user?.fullName ==
                                                          null
                                                      ? ""
                                                      : profileController
                                                          .user!.fullName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(" . . ."),
                                              sBoxHeight(4),
                                              Text("TUIT 3/4 🎓"),
                                            ],
                                          )),
                                      sBoxHeight(10),

                                      ///Edit Profile
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: MaterialButton(
                                          onPressed: () {},
                                          height: 30,
                                          child: Text("Edit profile"),
                                          minWidth: Get.width,
                                        ),
                                      ),

                                      ///Highlights
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 11, right: 11, top: 11),
                                        // height: 100,
                                        height: Get.height * 0.134,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            ///only for plus button on highlight list
                                            Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                  ),
                                                  child: Container(
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(Icons.add)),
                                                  ),
                                                ),
                                                sBoxHeight(7),
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
                                              itemCount: profileController
                                                  .images.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return storyMaker(
                                                    profileController, index);
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
                                        width: Get.width,
                                        child: GridView.builder(
                                          padding: EdgeInsets.only(top: 3),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              profileController.items.length,
                                          itemBuilder: (ctx, i) {
                                            return buildGrid(
                                                profileController, i);
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
                                        itemCount:
                                            profileController.items.length,
                                        itemBuilder: (ctx, i) {
                                          return buildGrid(
                                              profileController, i);
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
            );
          },
        ));
  }
}
