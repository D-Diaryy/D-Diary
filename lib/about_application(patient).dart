import 'package:flutter/material.dart';

class AboutAppPatient extends StatefulWidget {
  const AboutAppPatient({Key? key}) : super(key: key);

  @override
  State<AboutAppPatient> createState() => _AboutAppPatientState();
}

class _AboutAppPatientState extends State<AboutAppPatient> {
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      backgroundColor: const Color(0xff0c7085),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 300 / pixelRatio, 0.0, 0.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 300 / pixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 100 / pixelRatio, 0.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'About the Application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 70.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffec8420),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 50 / pixelRatio),
                            child: Text(
                              'D-Diary: Dementia Virtual Memory and Location Tracking App for Patients and Carers (D-VMLT) was formed by a group of college students of University of Santo Tomas as part of their collegiate project in Capstone. The project aims to improve the lives of people with dementia through developing new technologies that support their wellbeing and independence.\n\nD-Diary is an Android app that  allow Dementia Patients to upload media from their camera roll to their account, giving them a visual record of where they have been. It also allows the said user to share these media with their Carers, so it can help provide a better understanding of what the patient is experiencing or has experienced.\n\nThe application features a smart voice assistant integrated with Alan AI that helps people with dementia navigate through the interface with ease by speaking into the microphone of the phone and these are transcribed into text in real time. The smart voice assistant will respond with pre-recorded responses when necessary. It also has a Matching game where players have to match pictures based on memory cues. The game can be played at any time or place, with or without help from a carer or family member. Furthermore, it includes Location Tracking to allow carers to track the location of their patients using GPS on their smartphone.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 40.0 / pixelRatio,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xff000000),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'For inquiries and suggestions, please contact us at',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff0c7085),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 300 / pixelRatio),
                        child: Text(
                          'ddiaryteam@gmail.com',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 40.0 / pixelRatio,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0c7085),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
