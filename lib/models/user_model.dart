class UserModel {
  String uid = "";
  late String fullName;
  late String email;
  late String password;
  String? imgUrl;
  bool followed = false;
  int followersCount = 0;
  int followingCount = 0;

  UserModel(
      {required this.fullName, required this.email, required this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    email = json["email"];
    password = json["password"];
    imgUrl = json["imgUrl"];
    followersCount = json["followersCount"];
    followingCount = json["followingCount"];
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "email": email,
        "password": password,
        "imageUrl": imgUrl,
        "followersCount": followersCount,
        "followingCount": followingCount,
      };

  @override
  bool operator ==(Object other) {
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
