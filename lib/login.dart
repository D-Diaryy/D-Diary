import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/main.dart';

import 'create_notif.dart';
import 'database.dart';
import 'deactpage.dart';
import 'forgot_password.dart';
import 'login_home.dart';
import 'utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              padding: EdgeInsets.fromLTRB(0.0, 100 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 100.0 / pixelRatio,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 50 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Enter Credentials Below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0 / pixelRatio,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff0c7085),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
              child: TextFormField(
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && email == '' ? 'Enter your email' : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline_rounded, size: 30, color: const Color(0xffec8420),),
                  filled: true,
                  fillColor: const Color(0xffede2d8),
                  hintText: 'Password',
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Color(0xffec8420),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) =>
                password != null && password == '' ? 'Enter your password' : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
              child: GestureDetector(
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 50.0 / pixelRatio,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff893111),
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage())); },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
              child: Container(
                height: 160/pixelRatio,
                width: 400/pixelRatio,
                decoration: BoxDecoration(
                  color: const Color(0xffec8420),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: TextButton(
                      onPressed: signIn,
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 60.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 600 / pixelRatio, 32.0, 0.0),
              child: Text(
                'Don\'t have an account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0 / pixelRatio,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff893111),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 200 / pixelRatio),
              child: GestureDetector(
                child: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 50.0 / pixelRatio,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff893111),
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLogin())); },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getPatientData();
      String? token = await FirebaseMessaging.instance.getToken();
      if(currentUser!.deactTime.toDate().difference(DateTime.now()).inDays < -90){
        MyApp.navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context)=>Deactpage()));
        print("Account");
        return null;
      }else{
        FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).update({"token" : token,"Password":passwordController.text.trim(),"deactTime":Timestamp.fromDate(DateTime.now().add(Duration(days: 365*5))),});
      }

      if(currentUser!.type){
        if(!currentUser!.activated){
          String title = "Carer ${currentUser!.userName} Reactivated account";
          String body = "He/She can monitor you.";
          Notify(title: title, body: body).Patients(null);
          await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).update({'activated' : true});
        }
      }else{
        if(!currentUser!.activated){
          String title = "Your Patient ${currentUser!.userName} Reactivated account";
          String body = "You'll can see his/her info or You track again.";
          Notify(title: title, body: body).Carers(null);
          await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(currentUser!.userID).update({'activated' : true});
          await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).update({'activated' : true});
        }
      }
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);

  }
}

