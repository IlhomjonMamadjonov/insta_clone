import 'package:get/get.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/data_service.dart';

class FeedController extends GetxController {
  bool isLoading = false;
  List<Post> items = [];

  void apiLoadFeeds() async {
    isLoading = true;
    update();

    DataService.loadFeeds().then((posts) => {_resLoadFeeds(posts)});
  }

  void _resLoadFeeds(List<Post> posts) {
    items = posts;
    isLoading = false;
    update();
  }
  @override
  void onInit() {
    apiLoadFeeds();
    super.onInit();
  }
}
