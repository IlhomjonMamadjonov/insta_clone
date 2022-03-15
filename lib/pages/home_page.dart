import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  PageController pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          FeedPage(),
          SearchPage(),
          UploadPage(),
          LikesPage(),
          ProfilePage()
        ],
        onPageChanged: (int i) {
          setState(() {
            _currentIndex =i;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (int i) {
          _currentIndex = i;
          pageController.animateToPage(i,
              duration: Duration(milliseconds: 250), curve: Curves.easeIn);
        },
        activeColor: Color.fromRGBO(245, 96, 64, 1),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
              )),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 32)),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, size: 32)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle, size: 32)),
        ],
      ),
    );
  }
}
