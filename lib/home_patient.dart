import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'about_application(patient).dart';
import 'homepage(patient).dart';
import 'profile(patient).dart';
import 'settings(patient).dart';

class HomePatient extends StatefulWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  State<HomePatient> createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {
  late Position position;
  Timer? timer;
  int index = 0;

  final screens = [
    const HomeTabPatient(),
    const ProfileTabPatient(),
    const AboutAppPatient(),
    const SettingsPatient(),
  ];

  @override
  void initState() {
    super.initState();
    getPos();
    /*
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
     */
  }
  Future getPos() async {
    // try {
      position = await _determinePosition();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'Latitude': position.latitude,
        'Longitude': position.longitude,
      });
    // } catch (e) {
    //   Utils.showSnackBar(e.toString());
    // }
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
    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.person, size: 30),
      const Icon(Icons.textsms_outlined, size: 30),
      const Icon(Icons.settings_outlined, size: 30),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.cyan.shade900),
        ),
        child: CurvedNavigationBar(
          color: const Color(0xffE8E7E7),
          backgroundColor: Colors.transparent,
          //height: 60.0,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
