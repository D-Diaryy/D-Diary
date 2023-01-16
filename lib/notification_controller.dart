import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/splash_checkup.dart';
import 'package:patient_app/splash_medicine.dart';
import 'package:patient_app/splash_personal.dart';

import 'main.dart';

class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // DatabaseService(uid: '').getReminderData();
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //       (route) => (route.settings.name != '/notification-page') || route.isFirst,);
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    QuerySnapshot doc;
    var to;
    String toCode;
    print("Notif ID: "+receivedNotification.id.toString());
    if(currentUser!.type){
      to = receivedNotification.title!.split(" ").last;
      DocumentSnapshot userId = await FirebaseFirestore.instance.collection("patients").doc(to).get();
      FirebaseFirestore.instance.collection('users').doc(userId["UID"]).collection('notifications').add({
        "title" : receivedNotification.title,
        "body" : receivedNotification.body,
        "date" :'${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}-${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      //"date" : dateTime == null ? date : dateTime,
      });
      doc = await FirebaseFirestore.instance.collection('users').doc(userId["UID"]).collection('reminderss').where('Alarm ID',isEqualTo: receivedNotification.id!).get();
      DocumentSnapshot user = await FirebaseFirestore.instance.collection('users').doc(userId["UID"]).get();
      toCode = to;
      to = user["Username"];
    }else{
      doc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminderss').where('Alarm ID',isEqualTo: receivedNotification.id!).get();
      to = currentUser!.fullName;
      toCode = currentUser!.code.toString();
      FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('notifications').add({
        "title" : receivedNotification.title,
        "body" : receivedNotification.body,
        "date" : '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}-${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        //"date" : dateTime == null ? date : dateTime,
      });
    }
    notifDetails = await notifReminder.getData(doc,to,toCode);

    bool isInstalled = await DeviceApps.isAppInstalled('com.example.patient_app');
    if (isInstalled != false) {
      DeviceApps.openApp('com.example.patient_app');
      if(notifDetails!.nType == "Personal"){
        Navigator.pushReplacement(MyApp.navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>SplashPersonal()));
      }else if(notifDetails!.nType == "Medicine Intake"){
        Navigator.pushReplacement(MyApp.navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>SplashMedicine()));
      }else if(notifDetails!.nType == "Check Up"){
        Navigator.pushReplacement(MyApp.navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>SplashCheckUp()));
      }
      print("App is now open");
    }
    else   print("Cannot open app");
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
      MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
            (route) =>
        (route.settings.name != '/notification-page') || route.isFirst,);
  }
}
notifReminder? notifDetails;
class notifReminder{
  late String? nType;
  late String? nTitle;
  late String? nLocation;
  late String? nDosage;
  late int? id;
  late String? docId;
  late String? time;
  late String? to;
  late String? nNotes;
  late String? toCode;
  notifReminder({this.nType,this.nTitle,this.nLocation,this.nDosage,this.id,this.docId,this.time,this.to,this.nNotes,this.toCode});
  factory notifReminder.getData(QuerySnapshot doc,to,toCode){
    fixZero(x){
      return int.parse(x) < 10 ? 0.toString() + x : x;
    }
    if(!doc.docs.isEmpty){
      return notifReminder(
          nType : doc.docs[0]['Type'],
          nTitle : doc.docs[0]['Title'],
          nLocation : doc.docs[0]['Location'],
          nDosage : doc.docs[0]['Dosage'],
          id : doc.docs[0]["Alarm ID"],
          docId: doc.docs[0].id,
          time : doc.docs[0]['Hour'] + ":" + fixZero(doc.docs[0]['Minute']),
          to: to,
          nNotes : doc.docs[0]['Notes'],
          toCode : toCode
      );
    }else{
      return notifReminder();
    }
  }
}