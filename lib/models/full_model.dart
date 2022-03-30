class FullModel {
  late String postImage;
  late String userName;
  late String postedTime;
  String userImage;
  String? location;
  String? postCaption;
  int? postLikes;
  int? postComments;
  bool isLiked = false;

  FullModel(
      {required this.userName,
      required this.postImage,
      required this.userImage,
      this.location,
      this.postCaption,
      this.postComments,
      required this.isLiked,
      required this.postedTime,
      this.postLikes});

  FullModel.story({required this.userName, required this.userImage});
}
