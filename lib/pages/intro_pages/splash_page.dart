import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';

import '../../services/pref_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String id = "/splash_page";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _startPage()));
    });
  }
  _initNotification() async {
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
  void initState() {
    _initNotification();
    openPage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Center(
                      child: Container(
                          height: 80,
                          width: 80,
                          child: SvgPicture.asset("assets/images/logo.svg")))),
              Column(
                children: [
                  Text(
                    "from",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Container(height:40,width:110,child: Image.asset("assets/images/metaa.png"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
