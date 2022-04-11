import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/intro_controllers/signUp_controller.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';
import 'package:instagram_clone/views/button_widget.dart';
import 'package:instagram_clone/views/have_account_question.dart';
import 'package:instagram_clone/views/loading_widget.dart';
import 'package:instagram_clone/views/sized_box.dart';
import 'package:instagram_clone/views/textfield_widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = "/signUp_page";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SafeArea(
        child: GetBuilder<SignUpController>(
          init: SignUpController(),
          builder: (signUpController) {
            return Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: Get.width,
                      height: Get.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // #Icon
                              Container(
                                height: 110,
                                width: 110,
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.person,
                                  size: 70,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                              ),
                              sBoxHeight(20),
                              TabBar(
                                  indicatorColor: Colors.black,
                                  labelColor: Colors.black,
                                  controller: _tabController,
                                  tabs: [
                                    Tab(
                                      text: "EMAIL",
                                    ),
                                    Tab(
                                      text: "PHONE",
                                    ),
                                  ]),
                              SizedBox(
                                height: Get.height*0.33,
                                width: Get.width,
                                  child: TabBarView(
                                children: [
                                  Column(
                                    children: [
                                      sBoxHeight(10),

                                      // #fullname
                                      textfield(
                                        hintText: 'Fullname',
                                        controller:
                                            signUpController.nameController,
                                      ),
                                      sBoxHeight(10),

                                      // #email
                                      textfield(
                                          hintText: "Email",
                                          controller:
                                              signUpController.emailController),
                                      sBoxHeight(10),

                                      // #Password
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: Colors.grey.withOpacity(0.03)),
                                        child: TextField(
                                          controller: signUpController
                                              .passwordController,
                                          textInputAction: TextInputAction.next,
                                          obscureText:
                                              signUpController.isVisible
                                                  ? true
                                                  : false,
                                          decoration: InputDecoration(
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  signUpController.isVisibled();
                                                },
                                                child: Icon(signUpController
                                                        .isVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintText: "Password",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      sBoxHeight(10),

                                      // #Confirm Password
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: Colors.grey.withOpacity(0.03)),
                                        child: TextField(
                                          controller: signUpController
                                              .cpasswordController,
                                          textInputAction: TextInputAction.done,
                                          obscureText:
                                              signUpController.isVisible
                                                  ? true
                                                  : false,
                                          decoration: InputDecoration(
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  signUpController.isVisibled();
                                                },
                                                child: Icon(signUpController
                                                        .isVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintText: "Confirm Password",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //phone
                                  Column(
                                    children: [
                                      sBoxHeight(15),
                                      InternationalPhoneNumberInput(
                                        maxLength: 12,
                                        onInputChanged: (number) {
                                          print(number.phoneNumber);
                                        },
                                        onInputValidated: (bool value) {
                                          print(value);
                                        },
                                        selectorConfig: SelectorConfig(
                                          selectorType:
                                              PhoneInputSelectorType.DIALOG,
                                        ),
                                        ignoreBlank: true,
                                        autoValidateMode: AutovalidateMode.always,
                                        selectorTextStyle:
                                            TextStyle(color: Colors.black),
                                        initialValue:
                                            signUpController.number,
                                        textFieldController: signUpController
                                            .numberController,
                                        inputBorder: OutlineInputBorder(),
                                      ),
                                    ],
                                  ),
                                ],
                                controller: _tabController,
                              )),
                              // #text
                              Expanded(
                                child: Column(
                                  children: [
                                    sBoxHeight(10),
                                    Text(
                                      "You may receive SMS updates from Instagram and can opt out at any time.",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: Colors.grey.shade700),
                                    ),
                                    sBoxHeight(10),
                                    // #button sign in
                                    button(
                                        title: "Sign up",
                                        onPressed: signUpController.openHomePage)
                                  ],
                                ),
                              ),
                            ],
                          )),
                          Divider(
                            color: Colors.grey.shade800,
                          ),

                          // already have an account?
                          GestureDetector(
                              onTap: () {
                                Get.to(() => const SignInPage());
                              },
                              child: haveAccount(
                                  question: "Already have an account?",
                                  option: " Log in")),
                          sBoxHeight(20),
                        ],
                      ),
                    ),
                  ),
                  LoadingWidget(
                    isLoading: signUpController.isLoading,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
