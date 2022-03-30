import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/intro_pages/signIn_page.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/data_service.dart';
import 'package:instagram_clone/services/pref_service.dart';
import 'package:instagram_clone/utils/utils_service.dart';
import 'package:instagram_clone/utils/validation.dart';
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
  bool isVisible = true;
  PhoneNumber number = PhoneNumber(isoCode: 'UZ');
  late PhoneNumber phoneNum;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  bool isLoading = false;

  void _openSignInPage() async {
    String fullName = nameController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String confirmPassword = cpasswordController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if ((email.isEmpty ||
            password.isEmpty ||
            fullName.isEmpty ||
            confirmPassword.isEmpty) &&
        password == confirmPassword) {
      Utils.fireSnackBar("Please fill all the fields", context);
      return;
    }
    if (password != confirmPassword) {
      Utils.fireSnackBar(
          "Password and confirm password doesn't match!", context);
    }
    if (!Validators.isValidEmail(email)) {
      Utils.fireSnackBar(
        "Please, enter valid Email",
        context,
      );
      return;
    }

    if (!Validators.isValidPassword(password)) {
      Utils.fireSnackBar(
        "Password must be at least one upper case, one lower case, one digit, one Special character & be at least 8 characters in length",
        context,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    var modelUser =
        model.UserModel(password: password, email: email, fullName: fullName);
    await AuthService.signUpUser(modelUser).then((response) {
      _getFirebaseUser(modelUser, response);
    });
  }

  void _getFirebaseUser(
      model.UserModel modelUser, Map<String, User?> map) async {
    setState(() {
      isLoading = false;
    });

    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("weak-password"))
        Utils.fireSnackBar("The password provided is too weak.", context);
      if (map.containsKey("email-already-in-use"))
        Utils.fireSnackBar(
            "The account already exists for that email.", context);
      if (map.containsKey("ERROR"))
        Utils.fireSnackBar("Check Your Information.", context);
      return;
    }
    User? user = map["SUCCESS"];
    if (user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    modelUser.uid = user.uid;

    DataService.storeUser(modelUser).then(
        (value) => {Navigator.pushReplacementNamed(context, HomePage.id)});
  }

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
                          children: [
                            SizedBox(
                              height: 15,
                            ),
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
                              onPressed: _openSignInPage,
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
