import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/home_patient.dart';
import 'database.dart';

class MyNotifications extends StatefulWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final retDoc = snapshot.docs[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction)async{
            await FirebaseFirestore.instance.collection("users").doc(currentUser!.userID).collection("notifications").doc(retDoc.id).delete();
          },
          background: Container(color: Colors.amber),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
                //height: 40,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                    color: Color(0xff093f5c),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(children: [
                   Expanded(
                     flex: 1,
                     child: Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: 45,
                      child: CircleAvatar(backgroundImage: NetworkImage(currentUser!.profilePic),)
                  ),
                   ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          retDoc['title'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          retDoc['body'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          retDoc['date'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),
        );
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
            ),
          ]),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 29),
              child: Text(
                "Notifications",
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
            stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('notifications').orderBy("date",descending: true).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(
                child: _buildList(snapshot.data!),
              );
            },
          ),
        ],
      ),
    );
  }
}
