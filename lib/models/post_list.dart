import 'package:instagram_clone/models/full_model.dart';

class PostList {
  final List<FullModel> elements = [
    FullModel(
        isLiked: true,
        userName: "Boss",
        postedTime: DateTime.now().toString(),
        location: "Tashkent",
        postLikes: 77,
        postComments: 22,
        postCaption: "Helloooo",
        postImage: 'assets/images/img1.jpg',
        userImage: 'assets/images/img2.jpg'),
    FullModel(
        isLiked: true,
        userName: "Boss",
        postedTime: DateTime.now().toString(),
        location: "Tashkent",
        postLikes: 77,
        postComments: 22,
        postCaption: "daodwoind dowaindoad owdoad odiaod",
        postImage: 'assets/images/img2.jpg',
        userImage: 'assets/images/img2.jpg'),
    FullModel(
        isLiked: false,
        userName: "Boss",
        postedTime: DateTime.now().toString(),
        location: "Kokand city",
        postLikes: 77,
        postComments: 22,
        postCaption: "oionn ioandawd faeonawd ",
        postImage: 'assets/images/img3.jpg',
        userImage: 'assets/images/img1.jpg'),
    FullModel(
        isLiked: true,
        userName: "Boss",
        postedTime: DateTime.now().toString(),
        location: "London",
        postLikes: 77,
        postComments: 22,
        postCaption: "Helloooo",
        postImage: 'assets/images/img1.jpg',
        userImage: 'assets/images/img1.jpg'),
  ];
}
