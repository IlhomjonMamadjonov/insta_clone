import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/controllers/search_controller.dart';
import 'package:instagram_clone/views/item_of_user_search.dart';
import 'package:instagram_clone/views/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: GetBuilder<SearchController>(
        init: SearchController(),
        builder: (searchController){
          return Scaffold(
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
                        controller: searchController.controller,
                        onChanged: (keyword) {
                          searchController.apiSearchUsers(keyword);
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
                        itemCount: searchController.user.length,
                        itemBuilder: (context, index) => itemOfUser(searchController,searchController.user[index]),
                      ),
                    )
                  ],
                ),

             LoadingWidget(isLoading: searchController.isLoading,)
              ],
            ),
          );
        },
      ),
    );
  }
}
