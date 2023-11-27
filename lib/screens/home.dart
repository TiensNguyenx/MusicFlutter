import 'package:flutter/material.dart';
import 'package:music_ui/models/category.dart';
import 'package:music_ui/services/category_operations.dart';
import 'package:music_ui/services/music_operations.dart';

import '../models/music.dart';

class Home extends StatelessWidget {
  Function _miniPlayer;
  Home(this._miniPlayer);
  Widget createCategory(Category category) {
    return Container(
        color: Colors.blueGrey.shade400,
        child: Row(
          children: [
            Image.network(category.imageURL, fit: BoxFit.cover,height: 110,width: 110,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                category.name,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ));
  }

  List<Widget> createListOfCategories() {
    List<Category> categoryList = CategoryOperations.getCategories();
    List<Widget> categories = categoryList
        .map((Category category) => createCategory(category))
        .toList();
    return categories;
  }

  Widget createMusic(Music music) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 200,
              width: 200,
              child: InkWell(
                onTap: (){
                  _miniPlayer(music,stop:true);
                },
                child: Image.network(
                  music.image,
                  fit: BoxFit.cover,
                ),
              )),
          Text(
            music.name,
            style: TextStyle(color: Colors.white),
          ),
          Text(music.desc, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget createMusicList(String lable) {
    List<Music> musicList = MusicOperations.getMusic();
    return Padding(
      padding: const EdgeInsets.only(left: 10,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return createMusic(musicList[index]);
              },
              itemCount: musicList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget createGrid() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 280,
      child: GridView.count(
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: createListOfCategories(),
        crossAxisCount: 2,
      ),
    );
  }

  createAppBar(String message) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(message),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 10), child: Icon(Icons.logout))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: SafeArea(
          child: Container(
        child: Column(
          children: [
            createAppBar('Good morning'),

            createGrid(),
            createMusicList('Made for You'),
            // createMusicList('Popular PlayList')
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blueGrey.shade300, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.3])),
      )),
    );
  }
}
