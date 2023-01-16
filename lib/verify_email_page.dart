import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'home_carer.dart';
import 'home_patient.dart';
import 'utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

      if (!isEmailVerified) {
        sendVerificationEmail();

        timer = Timer.periodic(
          Duration(seconds: 3),
              (_) => checkEmailVerified(),
        );
      }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();

      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmailVerified) timer?.cancel();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user .sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch(e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? (currentUser!.type ? HomeCarer() : HomePatient())
      : Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xff0c7085),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
                    child: Text(
                      'Thanks for signing up!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 65.0 / MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 50 / MediaQuery.of(context).devicePixelRatio, 0.0, 0.0),
                    child: const Icon(Icons.mark_email_read_outlined, size: 30, color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 50 / MediaQuery.of(context).devicePixelRatio, 0.0, 32.0),
                    child: Text(
                      'Verify Your Email Address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 55.0 / MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / MediaQuery.of(context).devicePixelRatio, 32.0, 0.0),
              child: Text(
                'Hello,\nYou’re almost ready to start. Please check your email and click on the button to verify your email address to continue with the application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.0 / MediaQuery.of(context).devicePixelRatio,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 100 / MediaQuery.of(context).devicePixelRatio, 32.0, 100 / MediaQuery.of(context).devicePixelRatio),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      User user = await FirebaseAuth.instance.currentUser!;
                      await DatabaseService(uid: user.uid).deleteuser();
                      await user.delete();
                      FirebaseAuth.instance.signOut();
                    } catch (e) {
                      print(e.toString());
                      return null;
                    }
                    },
                  icon: Icon(Icons.email, size: 32, color: Color(0xff0c7085),),
                  label: Text(
                    'Cancel Verification',
                    style: TextStyle(
                      fontSize: 50.0 / MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff093f5c),
                      fontFamily: 'Inter',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                    primary: const Color(0xffede2d8),
                  ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / MediaQuery.of(context).devicePixelRatio, 32.0, 0.0),
              child: Text(
                'Thank you very much,\nD-Diary Team',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0 / MediaQuery.of(context).devicePixelRatio,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 300/MediaQuery.of(context).devicePixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xff0c7085),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
            ),
          ],
        ),
  );
}
