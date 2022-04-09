import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/pref_service.dart';
import 'package:instagram_clone/services/utils_service.dart';

class SignInController extends GetxController {
  bool isVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void openHomePage() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please complete all the field");
      return;
    }

    isLoading = true;
    update();
    await AuthService.signInUser(email, password).then((response) {
      _getFirebaseUser(response);
    });
  }

  void _getFirebaseUser(Map<String, User?> map) async {
    isLoading = false;
    update();

    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("user-not-found")) {
        Utils.fireSnackBar("No user found for that email.");
        return;
      }
      if (map.containsKey("wrong-password")) {
        Utils.fireSnackBar("Wrong password provided for that user.");
        return;
      }
      if (map.containsKey("ERROR"))
        Utils.fireSnackBar("Check Your Information.");
      return;
    }

    User? user = map["SUCCESS"];
    if (user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    Get.toNamed(HomePage.id);
  }

  void isVisibled() {
    isVisible = !isVisible;
    update();
  }
}
