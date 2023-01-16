import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils.dart';

import 'account_privacy_and_settings.dart';
import 'database.dart';
import 'home_carer.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
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
                  onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AccountPrivacySettings())); },
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
                    'CHANGE USERNAME',
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 150 / pixelRatio, 0, 0),
                        child: Text(
                          'Enter new username:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 45.0 / pixelRatio,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffec8420),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
                        child: SizedBox(
                          height: 120 / pixelRatio,
                          width: 600 / pixelRatio,
                          child: TextField(
                            controller: userNameController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                                fontSize: 40.0 / pixelRatio,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 100 / pixelRatio, 10.0, 150 / pixelRatio),
                              child: Container(
                                height: 100 / pixelRatio,
                                decoration: BoxDecoration(
                                  color: const Color(0xffec8420),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Change Username'),
                                          content: Text(
                                              'Are you sure you want to change your username?'
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                updateUsername();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'save',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 45.0 / pixelRatio,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                                      primary: const Color(0xffec8420),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding( 
                              padding: EdgeInsets.fromLTRB(10.0, 100 / pixelRatio, 20.0, 150 / pixelRatio),
                              child: Container(
                                height: 100 / pixelRatio,
                                decoration: BoxDecoration(
                                  color: const Color(0xffec8420),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AccountPrivacySettings()));
                                    },
                                    child: Text(
                                      'cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 45.0 / pixelRatio,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                                      primary: const Color(0xffec8420),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future updateUsername() async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'Username': userNameController.text.trim() == "" ? currentUser!.userName : userNameController.text.trim(),
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer()));
  }
}
