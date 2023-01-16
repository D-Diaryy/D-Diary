import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Deactpage extends StatefulWidget {
  const Deactpage({Key? key}) : super(key: key);

  @override
  State<Deactpage> createState() => _DeactpageState();
}

class _DeactpageState extends State<Deactpage> {
  @override
  void dispose() {
    FirebaseAuth.instance.signOut();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
    return Scaffold(
      body: Stack(
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login())); },
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                        child: Text(
                          "Your account has been deactivated for more than 3 months sorry to say you can access it anymore!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 23,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*.6,
                      child: ElevatedButton(
                        onPressed: () async{

                          },
                        child: Text(
                          'BACK TO LOGIN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 45.0 / pixelRatio,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(150 / MediaQuery.of(context).devicePixelRatio),
                          primary: const Color(0xffec8420),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}
