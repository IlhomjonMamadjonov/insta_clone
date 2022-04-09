import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/home_controller.dart';
import 'package:instagram_clone/pages/feed_page.dart';
import 'package:instagram_clone/pages/likes_page.dart';
import 'package:instagram_clone/pages/profile_page.dart';
import 'package:instagram_clone/pages/search_page.dart';
import 'package:instagram_clone/pages/upload_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "/home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(), builder: (homeController) {
      return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: homeController.pageController,
          children: [
            const FeedPage(),
            const SearchPage(),
            const UploadPage(),
            const LikesPage(),
            ProfilePage()
          ],
          onPageChanged: (int i) =>
              homeController.onPageChange(i)
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: homeController.currentIndex,
          onTap: (int i) =>
           homeController.onTapped(i),
          activeColor: Colors.black,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 32,
                )),
            const BottomNavigationBarItem(icon: Icon(Icons.search, size: 32)),
            const BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32)),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, size: 32)),
            BottomNavigationBarItem(
                icon: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/profile_page_img/profil_img.JPG"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
