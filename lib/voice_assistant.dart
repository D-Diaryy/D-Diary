import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/main.dart';

import 'about_me(patient).dart';
import 'about_sva.dart';
import 'albums(patient).dart';
import 'game_splash.dart';
import 'home_patient.dart';
import 'my_reminders(patient).dart';
bool isSwitched = false;
class VoiceAssistant extends StatefulWidget {
  const VoiceAssistant({Key? key}) : super(key: key);

  @override
  State<VoiceAssistant> createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 0, 0),
                child: Container(
                    height: 100 / pixelRatio,
                    width: 100 / pixelRatio,
                    decoration: const BoxDecoration(
                        color: Color(0xff093f5c), shape: BoxShape.circle),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xffede2d8),
                      size: 20,
                    )),
              ),
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                'Smart Voice\nAssistance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 70.0 / pixelRatio,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 150 / pixelRatio, 32.0, 0.0),
            child: Container(
              height: 500/pixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xffec8420),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 60 / pixelRatio, 0.0, 0.0),
                    child: Text(
                      'Click here to turn on smart\nvoice assistance feature',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 45.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SwitchScreen(),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 150 / pixelRatio),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                child: Text(
                  'What is Smart Voice\nAssistance?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 70.0 / pixelRatio,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffec8420),
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: (){
                  Navigator.push(MyApp.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>AboutSVA()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        AlanVoice.removeButton();
        AlanVoice.addButton(
          "53845e284342e9623b5f9c9a0c0bb9f72e956eca572e1d8b807a3e2338fdd0dc/stage",
          buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
        );
        AlanVoice.onCommand.add((command) => _handleCommand(command.data));
      });
    }
    else
    {
      setState(() {
        isSwitched = false;
        AlanVoice.removeButton();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 2,
      child: Switch(
        onChanged: toggleSwitch,
        value: isSwitched,
        activeColor: const Color(0xff893111),
        activeTrackColor: const Color(0xffede1cd),
        inactiveThumbColor: const Color(0xffede1cd),
        inactiveTrackColor: const Color(0xff893111),
      )
    );
  }

  void _handleCommand(Map<String, dynamic> command){final userType = currentUser!.type;
      switch(command["command"]) {
        case "reminder":
          Navigator.pushReplacement(MyApp.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>MyReminders()));
          break;
        case "game":
          Navigator.pushReplacement(MyApp.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>GameSplash()));
          break;
        case "info":
          Navigator.pushReplacement(MyApp.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>AboutMePatient()));
          break;
        case "album":
          Navigator.pushReplacement(MyApp.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>MyAlbum()));
          break;
        default:
          debugPrint("Unknown command");
      }
    }
  }
