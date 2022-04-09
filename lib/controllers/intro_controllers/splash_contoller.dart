import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';
import 'package:instagram_clone/services/pref_service.dart';

class SplashController extends GetxController{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Widget _startPage() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            Prefs.store(StorageKeys.UID, snapshot.data!.uid);
            return const HomePage();
          } else {
            Prefs.remove(StorageKeys.UID);
            return const SignInPage();
          }
        });
  }

  void openPage() {
    Timer(const Duration(seconds: 3), () {
      Get.off(_startPage());
    });
  }

  initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print(token);
      }
      Prefs.store(StorageKeys.TOKEN, token!);
    });
  }

  @override
  void onInit() {
    openPage();
    initNotification();
    super.onInit();
  }
}