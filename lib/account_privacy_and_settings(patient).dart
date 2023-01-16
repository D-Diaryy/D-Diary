import 'package:flutter/material.dart';
import 'package:patient_app/dialog.dart';

import 'change_password(patient).dart';
import 'change_username(patient).dart';
import 'deactivatepage.dart';

class AccountPrivacySettingsPatient extends StatefulWidget {
  const AccountPrivacySettingsPatient({Key? key}) : super(key: key);

  @override
  State<AccountPrivacySettingsPatient> createState() => _AccountPrivacySettingsPatientState();
}

class _AccountPrivacySettingsPatientState extends State<AccountPrivacySettingsPatient> {
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
              onTap: () { Navigator.pop(context); },
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
                'PRIVACY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff893111),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
            child: Container(
              // height: 500/pixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xffede2d8),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          Text(
                            'Change Username',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 45.0 / pixelRatio,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff893111),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, size: 100 / pixelRatio, color: Color(0xff893111),),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChangeUsernamePatient()));
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Color(0xffec8420),
                    thickness: 1.0,
                    indent: 50.0/pixelRatio,
                    endIndent: 50.0/pixelRatio,
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          Text(
                            'Change Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 45.0 / pixelRatio,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff893111),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, size: 100 / pixelRatio, color: Color(0xff893111),),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChangePasswordPatient()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                    child: Divider(
                      height: 10.0,
                      color: Color(0xffec8420),
                      thickness: 1.0,
                      indent: 50.0/pixelRatio,
                      endIndent: 50.0/pixelRatio,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 40, 0, 0),
              child: Text(
                'ACCOUNT DELETION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff893111),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
            child: Container(
              // height: 500/pixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xffede2d8),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          Text(
                            'Deactivate Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 45.0 / pixelRatio,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff893111),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, size: 100 / pixelRatio, color: Color(0xff893111),),
                        ],
                      ),
                    ),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) => MyDialog(height: 220, context: context).show()
                      );
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Color(0xffec8420),
                    thickness: 1.0,
                    indent: 50.0/pixelRatio,
                    endIndent: 50.0/pixelRatio,
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          Text(
                            'Automatically Delete Account if Away',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 45.0 / pixelRatio,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff893111),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, size: 100 / pixelRatio, color: Color(0xff893111),),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DeactPage()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                    child: Divider(
                      height: 10.0,
                      color: Color(0xffec8420),
                      thickness: 1.0,
                      indent: 50.0/pixelRatio,
                      endIndent: 50.0/pixelRatio,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
