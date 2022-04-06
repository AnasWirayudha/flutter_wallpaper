import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper/data/data.dart';
import 'package:flutter_wallpaper/model/wallpaper_model.dart';
import 'package:flutter_wallpaper/widgets/widgets.dart';
import 'package:http/http.dart' as http;


class Search extends StatefulWidget {
  final String searchQuery;
  Search({required this.searchQuery});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List<WallpaperModel> wallpapers = [];

  getSearchWallpapers(String query) async{
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=15&page=1"), 
    headers: {"Authorization": apiKey});

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search",  
                            border: InputBorder.none                      
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          getSearchWallpapers(searchController.text);
                        },
                        child: Container(
                          child: Icon(Icons.search)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                WallpapersList(
                  wallpapers: wallpapers, context: context),
              ],
            )
        ),
      )
    );
  }
}