import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/intro_controllers/signIn_controller.dart';
import 'package:instagram_clone/pages/intro_pages/signUp_page.dart';
import 'package:instagram_clone/views/button_widget.dart';
import 'package:instagram_clone/views/have_account_question.dart';
import 'package:instagram_clone/views/loading_widget.dart';
import 'package:instagram_clone/views/sized_box.dart';
import 'package:instagram_clone/views/textfield_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = "/signIn_page";

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
        init: SignInController(),
        builder: (signInController) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.only(bottom: 5, top: 20, left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // text instagram
                            Text(
                              "Instagram",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Billabong",
                                  fontSize: 50),
                            ),
                            sBoxHeight(15),
                            // #Email
                            textfield(
                                hintText: "Email",
                                controller: signInController.emailController),
                            sBoxHeight(10),
                            // #Password
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey.withOpacity(0.03)),
                              child: TextField(
                                controller: signInController.passwordController,
                                textInputAction: TextInputAction.done,
                                obscureText:
                                    signInController.isVisible ? true : false,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                          signInController.isVisibled();
                                      },
                                      child: Icon(signInController.isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            sBoxHeight(10),
                            // #button sign in
                            button(
                                title: "Log in",
                                onPressed: signInController.openHomePage),
                            sBoxHeight(15),
                            // extra helps
                            GestureDetector(
                                onTap: () {},
                                child: haveAccount(
                                    question: "Forgot your login details? ",
                                    option: "Get help logging in.")),
                            sBoxHeight(10),
                            Text(
                              " OR ",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 17),
                            ),
                            sBoxHeight(10),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.facebook),
                                    Text(" Continue as guest"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        Divider(
                          color: Colors.grey.shade800,
                        ),
                        sBoxHeight(5),
                        // already have an account??
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(SignUpPage.id);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        sBoxHeight(15)
                      ],
                    ),
                    LoadingWidget(isLoading: signInController.isLoading)
                  ],
                ),
              ),
            ),
          );
        });
  }
}
