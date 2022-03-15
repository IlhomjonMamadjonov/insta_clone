import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = "/signUp_page";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isVisible = true;
  PhoneNumber number = PhoneNumber(isoCode: 'UZ');
  late PhoneNumber phoneNum;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(),
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
                          border: Border.all(color: Colors.black, width: 2)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    Expanded(
                        child: TabBarView(
                      children: [
                        //email
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // #name
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey.withOpacity(0.03)),
                              child: TextField(
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: "FullName",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // #email
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey.withOpacity(0.03)),
                              child: TextField(
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // #Password
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey.withOpacity(0.03)),
                              child: TextField(
                                controller: passwordController,
                                textInputAction: TextInputAction.next,
                                obscureText: isVisible ? true : false,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      },
                                      child: Icon(isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            // #Confirm Password
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey.withOpacity(0.03)),
                              child: TextField(
                                controller: cpasswordController,
                                textInputAction: TextInputAction.done,
                                obscureText: isVisible ? true : false,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      },
                                      child: Icon(isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                        //phone
                        Column(
                          children: [SizedBox(height: 15,),
                            InternationalPhoneNumberInput(
                              maxLength: 12,
                              onInputChanged: (number) {
                                print(number.phoneNumber);
                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: true,
                              autoValidateMode: AutovalidateMode.always,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: numberController,
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You may recieve SMS updates from Instagram and can opt out at any time.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // #button sign in
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, HomePage.id);
                              },
                              child: Text("Sign up"),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                )),
                // already have an account??
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Log In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
                  // #Email
  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white.withOpacity(0.2)),
                    child: TextField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
 */
