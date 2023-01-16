import 'package:flutter/material.dart';
import 'package:patient_app/utils.dart';

import 'about_patients.dart';
import 'database.dart';
import 'dialog.dart';
import 'home_carer.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({Key? key}) : super(key: key);

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2: null;
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AboutPatients())); },
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
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                currentPatient!.fullName,
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
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(currentPatient!.profilePic),
              radius: 170/pixelRatio,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xffede2d8),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 18, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Username: ' + currentPatient!.userName,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Password: ' + currentPatient!.Password,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 20, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email: ' + currentPatient!.emailAdd,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Full Name: ' + currentPatient!.fullName,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nickname: ' + currentPatient!.userName,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Address: ' + currentPatient!.address,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Guardian/Primary Carer Contact Number: ' + currentPatient!.contact,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Birthdate: ' + currentPatient!.bday,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 0.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Age: ' + currentPatient!.age,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Dementia Stage: ' + currentPatient!.dementiaStage,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Self Description: ' + currentPatient!.description,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 200.0 / pixelRatio, 0.0, 0.0),
                  child: Icon(
                    Icons.delete_outline_outlined,
                    color: Color(0xff893111),
                    size: 130.0 / pixelRatio,
                  ),
                ),
                Text(
                  'Delete\nPatient',
                  style: TextStyle(
                    fontSize: 30.0 / pixelRatio,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff893111),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            onTap: () async {
              await DatabaseService(uid: '').getPatientCarers();
              if(currentCarers!.carerCnt == 1){
                Utils.showSnackBar('This patient has only 1 carer! You cannot delete this patient');
              }
              else{
                showDialog(
                  context: context,
                  builder: (_) => MyDialog(height: 200,context: context).show1(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
