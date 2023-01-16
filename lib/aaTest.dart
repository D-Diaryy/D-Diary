import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/splash_medicine.dart';

import 'notification_controller.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: ()async{
                      QuerySnapshot doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('reminderss').where('Alarm ID',isEqualTo: 2).get();
                      String to = "Nikko";
                      notifDetails = await notifReminder.getData(doc,to,6000.toString());
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SplashMedicine()));
                    },
                  child: Text("Open")
              ),
            ],
          ),
        ),
      )
    );
  }
}