import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/data_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<UserModel> user = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiSearchUsers("");
  }

  void _apiSearchUsers(String keyword) {
    setState(() {
      isLoading = true;
    });
    DataService.searchUsers(keyword).then((users) => _resSearchUser(users));
  }

  void _resSearchUser(List<UserModel> users) {
    setState(() {
      isLoading = false;
      user = users;
    });
  }

  void _apiFollowUser(UserModel someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.followUser(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnFollowUser(UserModel someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.unFollowUser(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }

  void updateFollow(UserModel user) {
    if(user.followed) {
      _apiUnFollowUser(user);
    } else {
      _apiFollowUser(user);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // #search
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: TextField(
                    controller: controller,
                    onChanged: (keyword) {
                      _apiSearchUsers(keyword);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200),),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade700,),
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey.shade800)
                    ),
                  ),
                ),

                // #users
                Expanded(
                  child: ListView.builder(
                    itemCount: user.length,
                    itemBuilder: (context, index) => itemOfUser(user[index]),
                  ),
                )
              ],
            ),

            if(isLoading) const Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
  Widget itemOfUser(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.purpleAccent, width: 2)
          ),
          padding: EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: user.imgUrl != null ? CachedNetworkImage(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              imageUrl: user.imgUrl!,
              placeholder: (context, url) => const Image(image: AssetImage("assets/images/default.jpg")),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ) : const Image(image: AssetImage("assets/images/default.jpg"), height: 40, width: 40,),
          ),
        ),
        title: Text(user.fullName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        subtitle: Text(user.email, style: TextStyle(color: Colors.black54,)),
        trailing: Container(
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: MaterialButton(
            onPressed: () => updateFollow(user),
            child: Text(user.followed ? "Following" : "Follow", style: TextStyle(color: Colors.black87,), ),
          ),
        ),
      ),
    );
  }
}
