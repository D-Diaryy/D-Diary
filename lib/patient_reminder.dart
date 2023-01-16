import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/view_reminder.dart';

import 'add_reminder.dart';
import 'create_notif.dart';
import 'database.dart';
import 'home_carer.dart';
import 'reminders.dart';

class PatientReminder extends StatefulWidget {
  const PatientReminder({Key? key}) : super(key: key);

  @override
  State<PatientReminder> createState() => _PatientReminderState();
}

class _PatientReminderState extends State<PatientReminder> {
  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final retDoc = snapshot.docs[index];
        var diff = DateTime.now().difference(DateTime(int.parse(retDoc['Year']),int.parse(retDoc['Month']),int.parse(retDoc['Day']),int.parse(retDoc['Hour']),int.parse(retDoc['Minute']))).inMinutes;
        bool del = false;
        if(diff > 1){
          FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('reminders').doc(retDoc.id).delete();
          del = true;
        }
        return !del ? Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 10),
          child: Container(
              //height: 40,
              decoration: const BoxDecoration(
                  color: Color(0xff093f5c),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(children: [
                 Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: CircleAvatar(
                    child: Image.network(retDoc['picture']),
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      retDoc['Title'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      retDoc['Month'] + '/' + retDoc['Day'] + '/' + retDoc['Year'] + ', ' + retDoc['Hour'] + ':' + retDoc['Minute'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: GestureDetector(
                    child: Text(
                      'Details',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () async {
                      await DatabaseService(uid: currentUser!.userID).showReminderData(retDoc.id);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ViewReminder()));
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                      height: 100 / MediaQuery.of(context).devicePixelRatio,
                      width: 100 / MediaQuery.of(context).devicePixelRatio,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      )),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddReminder(docId: retDoc.id,)));
                  },
                ),
                GestureDetector(
                  key: UniqueKey(),
                  child: Container(
                      height: 100 / MediaQuery.of(context).devicePixelRatio,
                      width: 100 / MediaQuery.of(context).devicePixelRatio,
                      decoration: const BoxDecoration(
                          color: Color(0xff893111), shape: BoxShape.circle),
                      child: const Icon(
                        Icons.delete,
                        color: Color(0xffede2d8),
                        size: 20,
                      )),
                  onTap: () async {
                        String title = "Carer ${currentUser!.userName} deleted a reminder";
                        String body = "a reminder has been deleted.";
                        Notify(title: title, body: body).Patient(
                            currentPatient!.userID,{
                              'dateTime': DateTime.now(),
                              'title' : "Deleted Alarm",
                              'id' : retDoc["Alarm ID"],
                              'type' : retDoc["Type"],
                              'category' : 'delete',
                              'time' : DateTime.now(),
                            }
                        );
                        Notify(title: title, body: body).OtherCarers(
                            {
                              'dateTime': DateTime.now(),
                              'title' : "Deleted Alarm",
                              'id' : retDoc["Alarm ID"],
                              'type' : retDoc["Type"],
                              'category' : 'delete',
                              'time' : DateTime.now(),
                            },currentPatient!.code.toString()
                        );
                        await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('reminders').doc(retDoc.id).delete();
                        await AwesomeNotifications().cancel(retDoc["Alarm ID"]);
                        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getCarers();
                    },
                ),
              ])),
        ) : Container();
        //   ListTile(
        //   title: Text(doc['UID'])
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Reminders())); },
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 32, 0),
                child: Container(
                    height: 100 / pixelRatio,
                    width: 100 / pixelRatio,
                    decoration: const BoxDecoration(
                        color: Color(0xff093f5c), shape: BoxShape.circle),
                    child: const Icon(
                      Icons.home,
                      color: Color(0xffede2d8),
                      size: 20,
                    )),
              ),
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer())); },
            ),
          ]),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 29),
              child: Text(
                currentPatient!.userName,
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('reminders').orderBy("DateAndTime",descending: true).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(
                child: _buildList(snapshot.data!),
              );
            },
          ),
          Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: Text('+ Add New Reminder',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60.0 / pixelRatio,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        shadows: const [
                          Shadow(color: Color(0xffec8420), offset: Offset(0, -3))
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xffec8420),
                        decorationThickness: 2,
                      )),
                  ),
                  onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddReminder())); },
                ),
              )
          )
        ],
      ),
    );
  }
}
