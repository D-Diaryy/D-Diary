import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'about_patients.dart';
import 'albums.dart';
import 'carer_notification.dart';
import 'database.dart';
import 'reminders.dart';
import 'track_patients.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  void initState(){
    super.initState();
  }
  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final retDoc = snapshot.docs[index];
        //createSplash(retDoc['Title'], retDoc['Year'], retDoc['Month'], retDoc['Day'], retDoc['Hour'], retDoc['Minute'],);
        return Container();
      },
    );
  }

  Widget _notify(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final retDoc = snapshot.docs[index];
        //newNotif(retDoc['title'], retDoc['body'], retDoc.id);
        return Container();
      },
    );
  }
  late num fixWidth;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
    MediaQuery.of(context).size.width > 500 ? fixWidth = 550 : fixWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/BgPic.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminders').snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();
                return Expanded(
                  child: _buildList(snapshot.data!),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 0 / pixelRatio, 32.0, 0.0),
              child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(currentUser!.profilePic) as ImageProvider,
                      radius: 100/pixelRatio,
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: const Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CarerNotifications()));
                      },
                    ),
                  ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 0.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, ' + currentUser!.userName,
                  style: TextStyle(
                    fontSize: 75.0 / pixelRatio,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 32, 32.0, 0.0),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AboutPatients()));
                              },
                              child: Image.asset(
                                'images/aboutpic.png',
                                width:(fixWidth-70)/2,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TrackPatients()));
                              },
                              child: Image.asset(
                                'images/trackpic.png',
                                width:(fixWidth-70)/2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 25 / pixelRatio, 32.0, 0.0),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Reminders()));
                              },
                              child: Image.asset(
                                'images/reminderspic.png',
                                width:(fixWidth-70)/2,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Albums()));
                              },
                              child: Image.asset(
                                'images/albumpic.png',
                                width:(fixWidth-70)/2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 80.0,
                        color: Colors.cyan.shade900,
                        thickness: 2.0,
                        indent: 96.0/pixelRatio,
                        endIndent: 96.0/pixelRatio,
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
