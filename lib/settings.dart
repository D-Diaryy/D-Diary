import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_privacy_and_settings.dart';
import 'database.dart';
import 'login_home.dart';

class SettingsCarer extends StatefulWidget {
  const SettingsCarer({Key? key}) : super(key: key);

  @override
  State<SettingsCarer> createState() => _SettingsCarerState();
}

class _SettingsCarerState extends State<SettingsCarer> {
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.2: null;
    return Scaffold(
      backgroundColor: const Color(0xff0c7085),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 300 / pixelRatio, 0.0, 0.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 300 / pixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 100 / pixelRatio, 0.0, 0.0),
                child: Column(
                  children: [
                    Center(child: Icon(Icons.settings_outlined, size: 300 / pixelRatio, color: Color(0xff0c7085),)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xffede2d8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.notifications, size: 90 / pixelRatio, color: Color(0xff893111),),
                                    Text(
                                      'Notifications and Sounds',
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
                                AppSettings.openNotificationSettings();
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
                                padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 90 / pixelRatio, color: Color(0xff893111),),
                                    Text(
                                      'Location Services',
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
                                AppSettings.openLocationSettings();
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
                                padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.lock, size: 90 / pixelRatio, color: Color(0xff893111),),
                                    Text(
                                      'Account Privacy & Settings',
                                      overflow: TextOverflow.ellipsis,
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountPrivacySettings()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
                      child: Container(
                        height: 165 / pixelRatio,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xffede2d8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: SignOut,
                            child: Text(
                              'Sign Out',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 45.0 / pixelRatio,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xff893111),
                                fontFamily: 'Inter',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                              backgroundColor: const Color(0xffede2d8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SignOut()async{
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({"token" : ""});
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeLogin()), (Route<dynamic> route) => false);
  }
}
