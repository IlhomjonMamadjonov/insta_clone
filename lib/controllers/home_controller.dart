import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:instagram_clone/services/utils_service.dart';

class HomeController extends GetxController{
  PageController pageController = PageController();
  int currentIndex = 0;

  initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message: ${message.notification.toString()}");
      Utils.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
  }
  @override
  void onInit() {
    pageController=PageController();
    initNotification();
    super.onInit();
  }

  void onTapped(int i){
   currentIndex = i;
   update();
    pageController.animateToPage(i,
        duration: Duration(milliseconds: 250), curve: Curves.easeIn);
  }
  void onPageChange(int index) {
    currentIndex = index;
    update();
  }
}