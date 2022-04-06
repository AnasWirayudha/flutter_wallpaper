import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper/views/categorie.dart';
import 'package:flutter_wallpaper/views/search.dart';
import 'package:flutter_wallpaper/widgets/widgets.dart';
import 'package:flutter_wallpaper/data/data.dart';
import 'package:flutter_wallpaper/model/categories_model.dart';
import 'package:flutter_wallpaper/model/wallpaper_model.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();

  getTrendingWallpapers() async{
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=15&page=1"), 
    headers: {"Authorization": apiKey});
    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {
      
    });
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0.0,
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
                          hintText: "Search Wallpaper",  
                          border: InputBorder.none                      
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                      Navigator.push(context,MaterialPageRoute(
                        builder: (context) => Search(searchQuery: searchController.text,
                        ),
                        ),
                      );
                      },
                      child: Container(
                        child: Icon(Icons.search)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoriesTile(
                      title: categories[index].categorieName!,
                      imgUrl: categories[index].imgUrl!,     
                    );
                  }),
              ),
              SizedBox(height: 16.0),
              WallpapersList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  String imgUrl, title;

  CategoriesTile({required this.imgUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Categorie(
            categorieName: title.toLowerCase(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 4.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imgUrl, height: 50, width: 100, fit: BoxFit.cover),
             ),
            Container(
              decoration: BoxDecoration( 
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              height: 50, width: 100,
              alignment: Alignment.center,
              child: Text(title, 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w500, 
                  fontSize: 15),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
