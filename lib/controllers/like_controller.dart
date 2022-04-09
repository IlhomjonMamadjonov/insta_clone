import 'package:get/get.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';

class LikeController extends GetxController {
  bool isLoading = true;
  List<Post> items = [];

  @override
  void onInit() {
    apiLoadLikes();
    super.onInit();
  }

  void apiLoadLikes() async {
    isLoading = true;
    update();
    DataService.loadLikes().then((posts) => {_resLoadLikes(posts)});
  }

  void _resLoadLikes(List<Post> posts) {
    items = posts;
    isLoading = false;
    update();
  }
}
