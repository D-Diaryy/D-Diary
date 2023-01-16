import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/utils.dart';

import 'database.dart';
import 'home_carer.dart';
import 'patient_details.dart';

class AboutPatients extends StatefulWidget {
  const AboutPatients({Key? key}) : super(key: key);

  @override
  State<AboutPatients> createState() => _AboutPatientsState();
}

class _AboutPatientsState extends State<AboutPatients> {
  final patientCodeController = TextEditingController();

  @override
  void dispose() {
    patientCodeController.dispose();

    super.dispose();
  }

  Future getPatient(String pUID) async{
    try {
      await DatabaseService(uid: pUID).getPatientData();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatientDetails()));
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
                'About My Patient/s',
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
              //

              //
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
                    child: Text('+ Add New Patient',
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
                  onTap: () {
                    openDialog();
                  },
                ),
              )
          )
        ],
      ),
    );
  }
  Future openDialog() => showDialog(
    context: context,
    builder: (context) =>AlertDialog(
      title: Text('Add New Patient'),
      content: TextField(
        controller: patientCodeController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter Patient Code',
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              try{
                await DatabaseService(uid: '').getPatientUID(patientCodeController.text.trim());
                await DatabaseService(uid: currentPatientUID?.userID as String).getPatientData();
                if (currentPatient!.activated) {
                  await FirebaseFirestore.instance.collection('carers').doc(currentUser!.code.toString()).collection('patients').doc(currentPatientUID?.userID).set({
                    'UID': currentPatient!.userID,
                    'User Type': currentPatient!.type,
                    'Full Name': currentPatient!.fullName,
                    'Email': currentPatient!.emailAdd,
                    'Username': currentPatient!.userName,
                    'Password': currentPatient!.Password,
                    'Address' : currentPatient!.address,
                    'Contact': currentPatient!.contact,
                    'Age': currentPatient!.age,
                    'Bday' : currentPatient!.bday,
                    'Code' : currentPatient!.code,
                    'Carer Code' : currentPatient!.carerCode,
                    'Latitude' : currentPatient!.lat,
                    'Longitude' : currentPatient!.long,
                    'Reminder Count' : currentPatient!.remCnt,
                    'Reminder Run' : currentPatient!.remRun,
                    'activated' : true,
                  }) ;
                  String token = await DatabaseService(uid: '').getToken(currentPatient!.userID);
                  await DatabaseService(uid: '').sendNotification("D-Diary Notification", "${currentUser!.userName} added you as patient!", token);
                  await FirebaseFirestore.instance.collection('patients').doc(currentPatient!.code.toString()).collection('carers').doc(currentUser?.userID).set({
                    'Carer Code': currentUser!.code.toString(),
                  });
                  await DatabaseService(uid: '').getPatientCarers();
                  await FirebaseFirestore.instance.collection('patients').doc(currentPatient!.code.toString()).update({
                    'Carer Count': currentCarers!.carerCnt + 1,
                  });
                }else{
                  Utils.showSnackBar("Patient ${patientCodeController.text.trim()} is not activated or account has been deleted!");
                }
               
              } on FirebaseAuthException catch(e) {
                print(e);

                Utils.showSnackBar(e.message);
              }
              Navigator.of(context).pop();
            },
            child: Text('Submit')
        ),
      ],
    ),
  );
}
