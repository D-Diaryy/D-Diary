import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'login_home.dart';
import 'utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLogin())); },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 500 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 75.0 / pixelRatio,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
              child: TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, size: 30, color: const Color(0xffec8420),),
                  filled: true,
                  fillColor: const Color(0xffede2d8),
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    fontSize: 50.0 / pixelRatio,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xffec8420),
                    fontFamily: 'Inter',
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: const Color(0xffede2d8)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: const Color(0xffede2d8)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  // do something
                },
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
                  child: TextButton(
                    onPressed: resetPassword,
                    child: Text(
                      'Click here for reset password link',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 43.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffec8420),
                        fontFamily: 'Inter',
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
  Future resetPassword() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
      //Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    } on FirebaseAuthException catch(e){
      print(e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
