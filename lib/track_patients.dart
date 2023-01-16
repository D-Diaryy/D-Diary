import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/utils.dart';

import 'database.dart';
import 'home_carer.dart';
import 'patient_map.dart';

class TrackPatients extends StatefulWidget {
  const TrackPatients({Key? key}) : super(key: key);

  @override
  State<TrackPatients> createState() => _TrackPatientsState();
}

class _TrackPatientsState extends State<TrackPatients> {
  Future getPatient(String pUID) async{
    try {
      await DatabaseService(uid: pUID).getPatientData();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatientMap()));
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }

  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        if(!snapshot.docs[index]['activated']){
          return Container();
        }
        final retDoc = snapshot.docs[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 5),
          child: ElevatedButton(
            onPressed: () {
              getPatient(retDoc['UID']);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    retDoc['Username'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff893111),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xff893111),
                      size: 15,
                    ),
                  ),
                ]),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(150 / MediaQuery.of(context).devicePixelRatio),
              backgroundColor: const Color(0xffede2d8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
            ),
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer())); },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'Track My Patients',
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
              padding: const EdgeInsets.fromLTRB(32, 40, 0, 0),
              child: Text(
                'PATIENTS LIST',
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('carers').doc(currentUser!.code.toString()).collection('patients').snapshots(),
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
