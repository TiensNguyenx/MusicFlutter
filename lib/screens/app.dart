import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_ui/screens/yourlibarary.dart';
import 'package:music_ui/screens/home.dart';
import 'package:music_ui/screens/search.dart';
import 'package:music_ui/models/music.dart';
import 'package:music_ui/services/music_operations.dart';
import '../models/music.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  List<Music> musicList = MusicOperations.getMusic();
  AudioPlayer _audioPlayer = new AudioPlayer();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  var Tabs = [];
  int currentTabIndex = 0;
  int currentSong = 0;
  bool isPlaying = false;
  Music? music;
  Widget miniPlayer(Music? music, {bool stop = false}) {
    this.music = music;

    if (music == null) {
      return SizedBox();
    }
    if (stop) {
      isPlaying = false;
      _audioPlayer.stop();
    }
    setState(() {});
    Size deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.black45,
      width: deviceSize.width,

      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Container(
                      width: 80,
                      height: 80,
                      child: Image.network(music.image, fit: BoxFit.cover)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 180,
                  child: Column(

                    children: [
                      Center(
                        child: Text(
                          music.name,
                          style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Center(
                        child: Text(
                          music.desc,
                          style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),),
                      )

                    ],
                  ),
                ),


                IconButton(
                  onPressed: () async {
                    await _audioPlayer
                        .play(UrlSource(musicList[currentSong - 1].audioURL));
                    currentSong--;
                    if (currentSong < 0) {
                      currentSong = 0;
                    }
                    setState(() {
                      this.music = musicList[currentSong];
                    });
                  },
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        await _audioPlayer.play(UrlSource(music.audioURL));
                      } else {
                        await _audioPlayer.pause();
                      }
                      setState(() {});
                    },
                    icon: isPlaying
                        ? Icon(Icons.pause, color: Colors.white)
                        : Icon(Icons.play_arrow, color: Colors.white)),
                IconButton(
                  onPressed: () async {
                    await _audioPlayer
                        .play(UrlSource(musicList[currentSong + 1].audioURL));
                    currentSong++;
                    // if(currentSong > musicList.length-1){
                    //   currentSong = 0;
                    // }
                    setState(() {
                      this.music = musicList[currentSong];
                    });
                  },
                  icon: Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                  ),
                ),

              ],
            ),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbColor: Colors.white,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Container(
                child: Slider(

                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0,left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position.inSeconds),style: TextStyle(color: Colors.white),),
                  Text(formatTime((position-duration).inSeconds),style: TextStyle(color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose(){
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });


    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    Tabs = [Home(miniPlayer), Search(), Yourlibrary()];



  }

  // UI Design Code Goes inside Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.blueGrey.shade400,
        child: ListView(
          children: [
            ListTile(
              title: Text('User'),textColor: Colors.black,
              leading: Icon(
                Icons.account_circle,
              ),
              onTap: (){},
            ),
            ListTile(
              title: Text('Log out'),
              leading: Icon(
                Icons.logout,
              ),

              onTap: (){},
            )
          ],
        ),
      ),
      body: Tabs[currentTabIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          miniPlayer(music),
          BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (currentIndex) {
              print("Current Index is $currentIndex");
              currentTabIndex = currentIndex;
              setState(() {}); // re-render
            },
            selectedLabelStyle: TextStyle(color: Colors.white),
            selectedItemColor: Colors.white,
            backgroundColor: Colors.black45,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_books, color: Colors.white),
                  label: 'Your Library')
            ],
          )
        ],
      ),
    );
  }
}