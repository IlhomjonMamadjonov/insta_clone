import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/chat_page.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';
import 'package:instagram_clone/pages/intro_pages/signUp_page.dart';
import 'package:instagram_clone/pages/intro_pages/splash_page.dart';
import 'package:instagram_clone/services/pref_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
Widget _startPage() {
  return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Prefs.store(StorageKeys.UID, snapshot.data!.uid);
          return const SplashPage();
        } else {
          Prefs.remove(StorageKeys.UID);
          return const SignInPage();
        }
      });
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insta clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _startPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        SplashPage.id:(context)=>SplashPage(),
        HomePage.id:(context)=>HomePage(),
        SignInPage.id:(context)=>SignInPage(),
        SignUpPage.id:(context)=>SignUpPage(),
        ChatPage.id:(context)=>ChatPage(),
      },
    );
  }
}
