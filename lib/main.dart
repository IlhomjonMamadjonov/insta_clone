import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/pages/chat_page.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';
import 'package:instagram_clone/pages/intro_pages/signUp_page.dart';
import 'package:instagram_clone/pages/intro_pages/splash_page.dart';
import 'package:instagram_clone/services/di_service.dart';

void main() async{
  await DIService.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// Notification
  var initAndroidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Insta clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: HomePage.id, page: () => const HomePage()),
        GetPage(name: ChatPage.id, page: () => const ChatPage()),
        GetPage(name: SignInPage.id, page: () => const SignInPage()),
        GetPage(name: SignUpPage.id, page: () => const SignUpPage()),
        GetPage(name: ChatPage.id, page: () => const ChatPage()),
      ],
    );
  }
}
