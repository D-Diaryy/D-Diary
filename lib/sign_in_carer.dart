import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/privacy_policy.dart';
import 'package:patient_app/terms_and_conditions.dart';

import 'constant.dart';
import 'login.dart';
import 'login_home.dart';
import 'utils.dart';

class SignInCarer extends StatefulWidget {
  const SignInCarer({Key? key}) : super(key: key);

  @override
  State<SignInCarer> createState() => _SignInCarerState();
}

class _SignInCarerState extends State<SignInCarer> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    userNameController.dispose();

    super.dispose();
  }
  bool checkedValue = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    if (!checkedValue) {
      return Colors.red;
    }else{
      return Color(0xffec8420);
    }
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      // backgroundColor: Colors.cyan.shade900,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    'Let\'s get started!',
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
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 25 / pixelRatio, 0.0, 0.0),
                child: Text(
                  'Create an account as Carer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0 / pixelRatio,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff0c7085),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Full Name',
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
                  validator: (name) =>
                  name != null && name == '' ? 'Enter your name' : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
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
                    email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: userNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Username',
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
                  validator: (userName) =>
                  userName != null && userName == '' ? 'Enter your username' : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
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
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xffec8420),
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 8
                      ? 'Enter min. 8 characters'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Confirm Password',
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
                        _confirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xffec8420),
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value!=passwordController.text.trim()
                      ? 'Password Doesn\'t Match!'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: Container(
                  height: 150/pixelRatio,
                  width: 350/pixelRatio,
                  decoration: BoxDecoration(
                    color: const Color(0xffec8420),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: signUp,
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 55.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: checkedValue,
                    onChanged: (bool? value) {
                      setState(() {
                        checkedValue = value!;
                      });
                    },
                  ),
                  Text(
                    'By creating an account or continuing to use D-Diary, you\nacknowledge and agree that you have read and',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff0c7085),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'accepted the ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35.0 / pixelRatio,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff0c7085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Terms and Conditions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0c7085),
                          fontFamily: 'Inter',
                        ),
                      ),
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditions())); },
                    ),
                    Text(
                      'and have reviewed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35.0 / pixelRatio,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff0c7085),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'the ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff0c7085),
                      fontFamily: 'Inter',
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 35.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0c7085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy())); },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
                child: Text(
                  'Already have an account as carer?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0 / pixelRatio,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff893111),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 50 / pixelRatio),
                child: GestureDetector(
                  child: Text(
                    'Sign in.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff893111),
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login())); },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (!checkedValue) {
      Utils.showSnackBar('Please Agree to terms and condition');
      return;
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await DatabaseService(uid: 'Null').getAppStatistics();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      String? token = await FirebaseMessaging.instance.getToken();
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateUserData(
            defaultpic,
            FirebaseAuth.instance.currentUser!.uid,
            true,
            fullNameController.text.trim(),
            emailController.text.trim(),
            userNameController.text.trim(),
            passwordController.text.trim(),
            '',
            '',
            '',
            '',
            currentStat!.carerCount + 1,
            '',
            0.0,
            0.0,
            0,
            0,
            '',
            token!,
            true,
            "",
            Timestamp.fromDate(DateTime.now().add(Duration(days: 365*5))),
            0,
      );
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
      //FIXTHIS
      await FirebaseFirestore.instance.collection('statistics').doc('statistics').update({
        'carerCount': currentStat!.carerCount + 1,
      });
      //, SetOptions(merge: true)
      await FirebaseFirestore.instance.collection('carers').doc(currentUser!.code.toString()).set({
        'UID': FirebaseAuth.instance.currentUser!.uid,
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

