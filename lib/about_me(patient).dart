import 'package:flutter/material.dart';

import 'ViewCarers.dart';
import 'database.dart';
import 'edit_profile(patient).dart';
import 'home_patient.dart';

class AboutMePatient extends StatefulWidget {
  const AboutMePatient({Key? key}) : super(key: key);

  @override
  State<AboutMePatient> createState() => _AboutMePatientState();
}

class _AboutMePatientState extends State<AboutMePatient> {
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'About Me',
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
              backgroundImage: NetworkImage(currentUser!.profilePic),
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
                        'Username: ' + currentUser!.userName,
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
                        'Password: ' + currentUser!.Password,
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
                        'Email: ' + currentUser!.emailAdd,
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
                        'Full Name: ' + currentUser!.fullName,
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
                        'Nickname: ' + currentUser!.userName,
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
                        'Address: ' + currentUser!.address,
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
                        'Guardian/Primary Carer Contact Number: ' + currentUser!.contact,
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
                        'Birthdate: ' + currentUser!.bday,
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
                        'Age: ' + currentUser!.age,
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
                    padding: EdgeInsets.fromLTRB(18.0, 5, 5.0, 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Dementia Stage: ' + currentUser!.dementiaStage,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),Padding(
                    padding: EdgeInsets.fromLTRB(18.0,5, 5.0, 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Self Description: ' + currentUser!.description,
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
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfilePatient()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0x00ffffff),
              shadowColor: Color(0x00ffffff),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 40.0 / pixelRatio, 0.0, 0.0),
              child: Column(
                children: [
                  Icon(
                    Icons.app_registration,
                    color: Color(0xff893111),
                    size: 130.0 / pixelRatio,
                  ),
                  Text(
                    'Edit About\nMe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff893111),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                    child: Text('View My Carers',
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ViewCarers()));
                  },
                ),
              )
          )
        ],
      ),
    );
  }
}
