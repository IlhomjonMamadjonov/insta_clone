import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/intro_controllers/splash_contoller.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String id = "/splash_page";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<SplashController>(
      init: SplashController(),
      builder: (splashController) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(),
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Center(
                        child: Container(
                            height: 80,
                            width: 80,
                            child:
                                SvgPicture.asset("assets/images/logo.svg")))),
                Column(
                  children: [
                    Text(
                      "from",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Container(
                        height: 40,
                        width: 110,
                        child: Image.asset("assets/images/metaa.png"))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
