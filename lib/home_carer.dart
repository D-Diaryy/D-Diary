import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'about_application.dart';
import 'homepage.dart';
import 'profile.dart';
import 'settings.dart';

class HomeCarer extends StatefulWidget {
  const HomeCarer({Key? key}) : super(key: key);

  @override
  State<HomeCarer> createState() => _HomeCarerState();
}

class _HomeCarerState extends State<HomeCarer> {
  int index = 0;

  final screens = [
    const HomeTab(),
    const ProfileTab(),
    const AboutApp(),
    const SettingsCarer(),
  ];

  @override
  void initState() {
    super.initState();
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
          animationDuration: const Duration(milliseconds: 400),
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
