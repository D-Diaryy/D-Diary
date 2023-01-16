import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils.dart';

import 'account_privacy_and_settings.dart';
import 'database.dart';
import 'home_carer.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool eop = false;
  bool enp = false;
  bool cnp = false;
  @override
  void dispose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
  Icon iconCheck(x){
    return x ? Icon(Icons.visibility,color: Color(0xffec8420),) : Icon(Icons.visibility_off,color: Color(0xffec8420));
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
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
                    'CHANGE PASSWORD',
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
                          'Enter old password:',
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
                        padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                        child: SizedBox(
                          width: 600 / pixelRatio,
                          child: TextFormField(
                            controller: oldPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: !eop,
                            style: TextStyle(
                              fontSize: 40.0 / pixelRatio,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    eop = !eop;
                                  });
                                },
                                icon:iconCheck(eop),
                              ),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != currentUser!.Password ? "Wrong Password!":null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 50 / pixelRatio, 0, 0),
                        child: Text(
                          'Enter new password:',
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
                        padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                        child: SizedBox(
                          width: 600 / pixelRatio,
                          child: TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: !enp,
                            style: TextStyle(
                              fontSize: 40.0 / pixelRatio,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    enp = !enp;
                                  });
                                },
                                icon:iconCheck(enp),
                              ),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.length < 6
                                ? 'Enter min. 6 characters'
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 50 / pixelRatio, 0, 0),
                        child: Text(
                          'Confirm new password:',
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
                        padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                        child: SizedBox(
                          width: 600 / pixelRatio,
                          child: TextFormField(
                            controller: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: !cnp,
                            style: TextStyle(
                              fontSize: 40.0 / pixelRatio,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    cnp = !cnp;
                                  });
                                },
                                icon:iconCheck(cnp),
                              ),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value!=passwordController.text.trim()
                                ? 'Password Doesn\'t Match!'
                                : null,
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
                                          title: Text('Change Password'),
                                          content: Text(
                                              'Are you sure you want to change your password?'
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
                                                updatePassword(oldPasswordController.text.trim(),passwordController.text.trim());
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
                                      backgroundColor: const Color(0xffec8420),
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
                                      backgroundColor: const Color(0xffec8420),
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

  Future updatePassword(String currentPassword, String newPassword) async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

        final user = await FirebaseAuth.instance.currentUser;
        final cred = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);
        user.reauthenticateWithCredential(cred).then((value) {
          user.updatePassword(newPassword).then((_) async {
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
              'Password': passwordController.text.trim(),
            });
          }).catchError((error) {
            print(error);
            Utils.showSnackBar(error.message.toString());
          });
        }).catchError((err) {
          Utils.showSnackBar(err.message.toString());
        });

    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer()));
  }
}
