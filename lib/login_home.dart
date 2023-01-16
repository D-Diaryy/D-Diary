import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/verify_email_first_time.dart';

import 'database.dart';
import 'login.dart';
import 'sign_in_carer.dart';
import 'sign_in_patient.dart';
import 'verify_email_page.dart';

class HomeLogin extends StatefulWidget {
  const HomeLogin({Key? key}) : super(key: key);

  @override
  State<HomeLogin> createState() => _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    //print(pixelRatio);
    pixelRatio < 2 ? pixelRatio = 2.1: null;
    return Scaffold(
      // backgroundColor: Colors.cyan.shade900,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/SplashBGs21.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 620 / pixelRatio, 0.0, 0.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/Logo.png',
                  width: 750/pixelRatio,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 100 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Dementia Virtual Memory and\nLocation Tracking Application for\nDementia Patients and Carers!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const Divider(
              height: 125.0,
              color: const Color(0x4dffffff),
              thickness: 2.0,
              indent: 36.0,
              endIndent: 36.0,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 0.0, 0.0, 0.0),
                  child: Container(
                    height: 172.5/pixelRatio,
                    width: 375/pixelRatio,
                    decoration: BoxDecoration(
                      color: const Color(0xffede2d8),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Something went wrong!'));
                                } else if (snapshot.hasData) {
                                  return FutureBuilder(
                                    future: buildwidget(),
                                    builder: (context, snapshot){
                                      if (snapshot.hasData) {
                                        return VerifyEmailFirstTime();
                                      }
                                      else {
                                        return SignInCarer();
                                      }
                                    },
                                  );
                                } else {
                                  return SignInCarer();
                                }
                              }
                            )));
                          },
                          child: Text(
                            'Register\n(As Carer)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40.0 / pixelRatio,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff093f5c),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 32.0, 0.0),
                  child: Container(
                    height: 172.5/pixelRatio,
                    width: 375/pixelRatio,
                    decoration: BoxDecoration(
                      color: const Color(0xffede2d8),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StreamBuilder<User?>(
                                stream: FirebaseAuth.instance.authStateChanges(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Something went wrong!'));
                                  } else if (snapshot.hasData) {
                                    return FutureBuilder(
                                      future: buildwidget(),
                                      builder: (context, snapshot){
                                        if (snapshot.hasData) {
                                          return VerifyEmailFirstTime();
                                        }
                                        else {
                                          return SignInPatient();
                                        }
                                      },
                                    );
                                  } else {
                                    return SignInPatient();
                                  }
                                }
                            )));
                          },
                          child: Text(
                            'Register\n(As Patient)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40.0 / pixelRatio,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff093f5c),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 100/pixelRatio, 0.0, 0.0),
              child: Container(
                height: 172.5/pixelRatio,
                width: 375/pixelRatio,
                decoration: BoxDecoration(
                  color: const Color(0xffede2d8),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Something went wrong!'));
                              } else if (snapshot.hasData) {
                                return FutureBuilder(
                                  future: buildwidget(),
                                  builder: (context, snapshot){
                                    if (snapshot.hasData) {
                                      return VerifyEmailPage();
                                    }
                                    else {
                                      return Login();
                                    }
                                  },
                                );
                              } else {
                                return Login();
                              }
                            }
                        )));
                      },
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff093f5c),
                          fontFamily: 'Inter',
                        ),
                      ),
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
  buildwidget() async{
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
    return 1;
  }

}

