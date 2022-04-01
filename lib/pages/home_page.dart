import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/feed_page.dart';
import 'package:instagram_clone/pages/likes_page.dart';
import 'package:instagram_clone/pages/profile_page.dart';
import 'package:instagram_clone/pages/search_page.dart';
import 'package:instagram_clone/pages/upload_page.dart';
import 'package:instagram_clone/utils/utils_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "/home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int _currentIndex = 0;

  _initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message: ${message.notification.toString()}");
      Utils.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    _initNotification();
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
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
              )),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 32)),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border, size: 32)),
          BottomNavigationBarItem(
              icon: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    image: DecorationImage(
                        image: AssetImage("assets/images/profile_page_img/profil_img.JPG"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
