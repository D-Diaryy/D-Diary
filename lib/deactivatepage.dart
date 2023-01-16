import 'package:flutter/material.dart';
import 'package:patient_app/account_privacy_and_settings(patient).dart';
import 'package:patient_app/account_privacy_and_settings.dart';

import 'database.dart';

class DeactPage extends StatefulWidget {
  const DeactPage({Key? key}) : super(key: key);

  @override
  State<DeactPage> createState() => _DeactPageState();
}

class _DeactPageState extends State<DeactPage> {
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
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
              onTap: () { currentUser!.type ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AccountPrivacySettings()))
                  : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AccountPrivacySettingsPatient()));},
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'Account Privacy and\nSettings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(32, 200 / pixelRatio, 0, 0),
              child: Text(
                'ACCOUNT DELETION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff893111),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Account will be automatically deleted when inactive for",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      color: Color(0xffec8420)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "3 Months",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: Color(0xffec8420)
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
