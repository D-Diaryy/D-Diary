import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/game_results.dart';

import 'game_logic.dart';
import 'game_splash.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  GameClass _game = GameClass();
  int score = 0;
  int time = 0;
  Timer? timer;
  bool gameInit = false;
  @override
  void initState(){
    super.initState();

    Timerr();

  }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
  ImageProvider ImgCheck(link){
    if(Uri.parse(link).isAbsolute){
      return NetworkImage(link);
    }else{
      return AssetImage(link);
    }
  }
  initGame()async{
    if(gameInit) {
      return 1;
    }
    await DatabaseService(uid: currentUser!.userID).getAlbums();
    await _game.initCard(myGallery?.imageList);
    _game.initGame();
    gameInit = true;
    return 1;
  }
  Timerr(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time++;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/gameBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 32, 0),
                      child: Container(
                          height: 100 / pixelRatio,
                          width: 100 / pixelRatio,
                          decoration: const BoxDecoration(
                              color: Color(0xffdffffff), shape: BoxShape.circle),
                          child: Icon(
                            Icons.cancel,
                            color: Color(0xffFF0000),
                            size: 100 / pixelRatio,
                          )),
                    ),
                    onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GameSplash())); },
                  ),
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Time: ' + '${time}s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 50 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Score: ' + '${score}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 90.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 600 / pixelRatio,
                child: FutureBuilder(
                 future: initGame(),
                  builder: (context, snapshot){
                    return snapshot.hasData ?  GridView.builder(
                        itemCount: 12,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3/4,
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                _game.gameImg![index] = _game.cards_list[index];
                                _game.matchCheck.add({index: _game.cards_list[index]});
                              });
                              if(_game.matchCheck.length == 2){
                                if(_game.matchCheck[0].values.first == _game.matchCheck[1].values.first){
                                  score += 100;
                                  if (score == 600) {
                                    timer!.cancel();
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GameResults(time:time)));
                                  }
                                  _game.matchCheck.clear();
                                }
                                else{
                                  Future.delayed(Duration(milliseconds: 500), (){
                                    setState(() {
                                      _game.gameImg![_game.matchCheck[0].keys.first] = _game.hiddenCardpath;
                                      _game.gameImg![_game.matchCheck[1].keys.first] = _game.hiddenCardpath;
                                      _game.matchCheck.clear();
                                    });
                                  });
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffec8420),
                                image: DecorationImage(image: ImgCheck(_game.gameImg![index]),fit: BoxFit.cover),
                              ),
                            ),
                          );
                        }
                    ) : Center(child: CircularProgressIndicator(),);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
