import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patient_app/database.dart';

import 'home_carer.dart';
import 'home_patient.dart';
import 'login_home.dart';

Timer? timer;
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }
  printMe(){

  }
  initInfo(){
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      //if(message.notification!.body == "Reminder has been added."){
        print("notif received");
        await Future.delayed(Duration(milliseconds: 500));
        await DatabaseService(uid: '').checkReminder();
      //}
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(), htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),htmlFormatTitle: true
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('dbfood','dbfood', importance: Importance.high,styleInformation: bigTextStyleInformation, priority: Priority.high,playSound: true);
      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show((1 + Random().nextInt(1000 - 1)).toInt(), message.notification!.title, message.notification!.body, platformChannelSpecifics,payload: message.data['title']);
    });


  }
  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User Granted Permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User Granted Provisional Permission');
    }else{
      print('User decline or not accepted permission');
    }

  }
  _navigatetohome()async{
    requestPermission();
    initInfo();
    await Future.delayed(Duration(milliseconds: 5000), (){});
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
                  DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).getUserData();
                  return currentUser!.type ? HomeCarer() : HomePatient();
                }else {
                  return HomeLogin();
                }
              },
            );
          } else {
            return HomeLogin();
          }
        }
    )));
  }
  buildwidget() async{
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
    return 1;
  }
  late Position position;
  Future getPos() async {
    try {
      position = await _determinePosition();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'Latitude': position.latitude,
        'Longitude': position.longitude,
      });
    } catch (e) {
       print(e.toString());
    }
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    //DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).getUserData();
    //if(!currentUser!.type){
        Timer.periodic(Duration(seconds: 60), (timer) async {
          await DatabaseService(uid: "").checkReminder();
          await getPos();
        });
    //}
    var pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    return Scaffold(
      // backgroundColor: Color(0xff093f5c),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/SplashBGs21.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 600 / pixelRatio, 0.0, 0.0),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'images/Logo.png',
              width: 1080/pixelRatio,
            ),
          ),
        ),
      ),
    );
  }
}
