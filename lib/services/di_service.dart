import 'package:get/get.dart';
import 'package:instagram_clone/controllers/feed_controller.dart';
import 'package:instagram_clone/controllers/home_controller.dart';
import 'package:instagram_clone/controllers/intro_controllers/signIn_controller.dart';
import 'package:instagram_clone/controllers/intro_controllers/signUp_controller.dart';
import 'package:instagram_clone/controllers/intro_controllers/splash_controller.dart';
import 'package:instagram_clone/controllers/like_controller.dart';
import 'package:instagram_clone/controllers/profile_controller.dart';
import 'package:instagram_clone/controllers/search_controller.dart';
import 'package:instagram_clone/controllers/upload_controller.dart';

class DIService {
  static Future<void> init() async {
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => FeedController(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
    Get.lazyPut(() => UploadController(), fenix: true);
    Get.lazyPut(() => LikeController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
