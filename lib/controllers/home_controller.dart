import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:instagram_clone/services/utils_service.dart';

class HomeController extends GetxController {
  late PageController pageController;
  int currentIndex = 0;

  initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("Message: ${message.notification.toString()}");
      }
      Utils.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
  }

  void onTapped(int i) {
    currentIndex = i;
    update();
    pageController.jumpToPage(i);
  }

  void onPageChange(int index) {
    currentIndex = index;
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    initNotification();
    super.onInit();
  }
}
