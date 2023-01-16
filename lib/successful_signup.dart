import 'package:flutter/material.dart';
import 'package:patient_app/home_carer.dart';
import 'package:patient_app/home_patient.dart';

import 'database.dart';

class SuccessfulSignup extends StatefulWidget {
  const SuccessfulSignup({Key? key}) : super(key: key);

  @override
  State<SuccessfulSignup> createState() => _SuccessfulSignupState();
}

class _SuccessfulSignupState extends State<SuccessfulSignup> {

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    return Scaffold(
      backgroundColor: Color(0xffede2d8),
      body: Container(
        child: Center(
          child: TextButton(style: TextButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)),
            child: Text(
              'Congratulations!\n\nYou have successfully\ncreated\nan account.\n\nClick anywhere to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45.0 / pixelRatio,
                fontWeight: FontWeight.bold,
                color: const Color(0xff893111),
                fontFamily: 'Inter',
              ),
            ),
            onPressed: (){
              if(currentUser!.type == true){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer()));
              }
              else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient()));
              }
            }
          ),
        ),
      ),
    );
  }
}
