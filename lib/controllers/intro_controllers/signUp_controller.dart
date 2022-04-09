import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/pref_service.dart';
import 'package:instagram_clone/services/utils_service.dart';
import 'package:instagram_clone/views/validation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpController extends GetxController{
  bool isVisible = true;
  PhoneNumber number = PhoneNumber(isoCode: 'UZ');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  bool isLoading = false;
 Future openHomePage() async {
    String fullName = nameController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String confirmPassword = cpasswordController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if ((email.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        confirmPassword.isEmpty) &&
        password == confirmPassword) {
      Utils.fireSnackBar("Please fill all the fields");
      return;
    }

    if (password != confirmPassword) {
      Utils.fireSnackBar(
          "Password and confirm password doesn't match!");
    }
    if (!Validators.isValidEmail(email)) {
      Utils.fireSnackBar(
        "Please, enter valid Email",
      );
      return;
    }

    if (!Validators.isValidPassword(password)) {
      Utils.fireSnackBar(
        "Password must be at least one upper case, one lower case, one digit, one Special character & be at least 8 characters in length",
      );
      return;
    }

    isLoading=true;
    update();
    var modelUser =
    model.UserModel(password: password, email: email, fullName: fullName);
    await AuthService.signUpUser(modelUser).then((response) {
      _getFirebaseUser(modelUser, response);
    });
  }
  void _getFirebaseUser(
      model.UserModel modelUser, Map<String, User?> map,) async {
    isLoading=false;
    update();

    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("weak-password"))
        Utils.fireSnackBar("The password provided is too weak.");
      if (map.containsKey("email-already-in-use"))
        Utils.fireSnackBar(
            "The account already exists for that email.");
      if (map.containsKey("ERROR"))
        Utils.fireSnackBar("Check Your Information.",);
      return;
    }
    User? user = map["SUCCESS"];
    if (user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    modelUser.uid = user.uid;

    DataService.storeUser(modelUser).then(
            (value) => Get.off(HomePage.id));
  }
  void isVisibled() {
    isVisible = !isVisible;
    update();
  }
}