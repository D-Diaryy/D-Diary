import 'package:flutter/material.dart';

import 'game.dart';
import 'home_patient.dart';

class GameSplash extends StatefulWidget {
  const GameSplash({Key? key}) : super(key: key);

  @override
  State<GameSplash> createState() => _GameSplashState();
}

class _GameSplashState extends State<GameSplash> {

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Flip and Match the\nCards!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 100.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 200.0 / pixelRatio, 0.0, 0.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/gameLogo.png',
                  width: 700/pixelRatio,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 150 / pixelRatio, 32.0, 0.0),
              child: Container(
                height: 150 / pixelRatio,
                width: 350 / pixelRatio,
                decoration: BoxDecoration(
                  color: const Color(0xffec8420),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Game())); },
                    child: Text(
                      'Play',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 70.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                      primary: const Color(0xffec8420),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
              child: Container(
                height: 150 / pixelRatio,
                width: 350 / pixelRatio,
                decoration: BoxDecoration(
                  color: const Color(0xffec8420),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
                    child: Text(
                      'Exit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 70.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                      primary: const Color(0xffec8420),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
