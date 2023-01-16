

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/settings(patient).dart';
import 'package:patient_app/settings.dart';

import 'about_patients.dart';
import 'create_notif.dart';
import 'database.dart';
import 'login_home.dart';

class MyDialog{
    int height;
    final context;
    MyDialog({required this.height,required this.context});
    show(){
    var emailController = TextEditingController();
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
    print(MediaQuery.of(context).size.width * .5);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: height.toDouble(),
        width: MediaQuery.of(context).size.width * 0.8 ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Enter Password to deactivate!",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Inter",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, size: 30, color: const Color(0xffec8420),),
                  filled: true,
                  fillColor: const Color(0xffede2d8),
                  hintText: 'Your Password',
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
                validator: (pass) =>
                pass != currentUser!.Password
                    ? 'Incorrect Password!'
                    : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 18.0),)
                ),
                TextButton(
                    onPressed: () {
                      if(currentUser!.Password == emailController.text.trim()){
                        showDialog(
                            context: context, builder: (_) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                child: Container(
                                  height: height.toDouble() * 1.6,
                                  width: MediaQuery.of(context).size.width * 0.9 ,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Account Deactivation is Temporary for 3 months.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "If you wish to reactivate your account, just login again with your username and password.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "If your account has not been reactivated after 3 months, the application will automatically delete your account.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Do you wish to continue Deactivation?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            height: 110/pixelRatio,
                                            width: 280/pixelRatio,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffec8420),
                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                onPressed: (){
                                                 // currentUser!.type ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SettingsCarer())) :
                                                  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SettingsPatient()));
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'No',
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
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            height: 110/pixelRatio,
                                            width: 280/pixelRatio,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffec8420),
                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                onPressed: () async {
                                                  if(currentUser!.type){
                                                    try {
                                                      User user = await FirebaseAuth.instance.currentUser!;
                                                      await DatabaseService(uid: user.uid).deleteuser();
                                                      //await user.delete();
                                                      String title = "Carer ${currentUser!.userName} Deactivated account";
                                                      String body = "Carer has been removed.";
                                                      Notify(title: title, body: body).Patients(null);
                                                      FirebaseAuth.instance.signOut();
                                                      await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeLogin()), (Route<dynamic> route) => false);
                                                    } catch (e) {
                                                      print(e.toString());
                                                      return null;
                                                    }
                                                  }else{
                                                    try {
                                                      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getCarerUID(currentUser!.carerCode);
                                                      User user = await FirebaseAuth.instance.currentUser!;
                                                      await DatabaseService(uid: user.uid).deleteuser();
                                                      String title = "Your Patient ${currentUser!.userName} Deactivated account";
                                                      String body = "You'll never see his/her info or track he/she.";
                                                      Notify(title: title, body: body).Carers(null);
                                                      FirebaseAuth.instance.signOut();
                                                      await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeLogin()), (Route<dynamic> route) => false);
                                                    } catch (e) {
                                                      print(e.toString());
                                                      return null;
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Yes',
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
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                        });
                      }else{
                        showDialog(
                            context: context, builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                            child: Container(
                              height: height.toDouble(),
                              width: MediaQuery.of(context).size.width * 0.8 ,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Wrong Password!",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Back',
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontSize: 20.0),)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      }
                    },
                    child: Text(
                      'Deactivate',
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 18.0),)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  show1(){
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          height: height.toDouble(),
          width: MediaQuery.of(context).size.width * 0.8 ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Are you sure you want to delete this patient from your patient list? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Color(0xffEC8420),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close,color: Colors.white,)
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Color(0xffEC8420),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                              onPressed: ()async{
                                await FirebaseFirestore.instance.collection('carers').doc(currentUser!.code.toString()).collection('patients').doc(currentPatient!.userID).delete();
                                await FirebaseFirestore.instance.collection('patients').doc(currentPatient!.code.toString()).collection('carers').doc(currentUser!.userID).delete();
                                await FirebaseFirestore.instance.collection('patients').doc(currentPatient!.code.toString()).update({
                                  'Carer Count': currentCarers!.carerCnt - 1,
                                });
                                await DatabaseService(uid: '').getPatientCarers();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AboutPatients()));
                              },
                              icon: Icon(Icons.check,color: Colors.white,)

                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      );
  }
}