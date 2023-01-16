
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/voice_assistant.dart';

import 'about_me(patient).dart';
import 'albums(patient).dart';
import 'database.dart';
import 'game_splash.dart';
import 'my_reminders(patient).dart';
import 'notifications(patient).dart';

class HomeTabPatient extends StatefulWidget {
  const HomeTabPatient({Key? key}) : super(key: key);

  @override
  State<HomeTabPatient> createState() => _HomeTabPatientState();
}

class _HomeTabPatientState extends State<HomeTabPatient> {
  @override
  void initState() {
    super.initState();
  }
  late num fixWidth;


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
    MediaQuery.of(context).size.width > 500 ? fixWidth = 650 : fixWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/BgPic.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 194.02 / pixelRatio, 32.0, 0.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentUser!.profilePic),
                    radius: 100/pixelRatio,
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    ),
                    onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyNotifications()));

                      },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 0.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, ' + currentUser!.userName,
                  style: TextStyle(
                    fontSize: 75.0 / pixelRatio,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AboutMePatient()));
                            },
                            child: Image.asset(
                              'images/aboutpic(patient).png',
                              width: (fixWidth-70)/2,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GameSplash()));
                            },
                            child: Image.asset(
                              'images/gamepic(patient).png',
                              width: (fixWidth-70)/2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 25 / pixelRatio, 32.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyReminders()));
                            },
                            child: Image.asset(
                              'images/reminderspic(patient).png',
                              width:(fixWidth-70)/2,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyAlbum()));
                            },
                            child: Image.asset(
                              'images/albumpic(patient).png',
                              width: (fixWidth-70)/2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 25 / pixelRatio, 32.0, 0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VoiceAssistant()));
                        },
                        child: Image.asset(
                          'images/voiceassistant(patient).png',
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Divider(
                      height: 80.0,
                      color: Colors.cyan.shade900,
                      thickness: 2.0,
                      indent: 96.0/pixelRatio,
                      endIndent: 96.0/pixelRatio,
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}