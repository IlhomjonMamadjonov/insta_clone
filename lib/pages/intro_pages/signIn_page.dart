import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/intro_pages/signUp_page.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/services/pref_service.dart';
import 'package:instagram_clone/utils/utils_service.dart';
import 'package:instagram_clone/widgets/button_widget.dart';
import 'package:instagram_clone/widgets/textfield_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = "/signIn_page";

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _openHomePage() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please complete all the fields", context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    await AuthService.signInUser(email, password).then((response) {
      _getFirebaseUser(response);
    });
  }

  void _getFirebaseUser(Map<String, User?> map) async {
    setState(() {
      isLoading = false;
    });

    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("user-not-found")) {
        Utils.fireSnackBar("No user found for that email.", context);
        return;
      }
      if (map.containsKey("wrong-password")) {
        Utils.fireSnackBar("Wrong password provided for that user.", context);
        return;
      }
      if (map.containsKey("ERROR"))
        Utils.fireSnackBar("Check Your Information.", context);
      return;
    }

    User? user = map["SUCCESS"];
    if (user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 5, top: 20, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
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
                        SizedBox(
                          height: 15,
                        ),
                        // #Email
                        textfield(hintText: "Email", controller: emailController),
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
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // #button sign in
                    button(title: "Log in", onPressed: _openHomePage),
                        SizedBox(
                          height: 15,
                        ),
                        // extra helps
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Forgot your login details? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "Get help logging in.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          " OR ",
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 17),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                SizedBox(
                  height: 5,
                ),
                // already have an account??
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage()));
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
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink()
          ],),
        ),
      ),
    );
  }
}
