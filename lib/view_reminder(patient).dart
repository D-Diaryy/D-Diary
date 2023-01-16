import 'package:flutter/material.dart';

import 'database.dart';
import 'home_patient.dart';
import 'my_reminders(patient).dart';

class ViewReminderPatient extends StatefulWidget {
  const ViewReminderPatient({Key? key}) : super(key: key);

  @override
  State<ViewReminderPatient> createState() => _ViewReminderPatientState();
}

class _ViewReminderPatientState extends State<ViewReminderPatient> {

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32, 100 / pixelRatio, 0, 0),
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
                onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyReminders())); },
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 100 / pixelRatio, 32, 0),
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50 / pixelRatio, 0, 0),
              child: Container(
                height: MediaQuery.of(context).size.height - 250 / pixelRatio,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(0xff093f5c),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(children: [
                    Center(
                      child: Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Container(
                        //height: 90,
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        decoration: const BoxDecoration(
                            color: Color(0xfffefefe),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 30 / pixelRatio, 0, 20 / pixelRatio),
                                child: SizedBox(
                                  height: 100.0 / pixelRatio,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Title: ' + currentReminder!.title,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0c7085),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 30 / pixelRatio, 0, 20 / pixelRatio),
                                child: SizedBox(
                                  height: 100.0 / pixelRatio,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Notes: ' + currentReminder!.notes,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0c7085),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Container(
                        //height: 155,
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        decoration: const BoxDecoration(
                            color: Color(0xfffefefe),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 30 / pixelRatio, 0, 30 / pixelRatio),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Date: ' + currentReminder!.month + '/' + currentReminder!.day + '/' + currentReminder!.year,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0c7085),
                                          fontFamily: 'Inter',
                                        )),
                                    Icon(
                                      Icons.calendar_month,
                                      color: Color(0xff0c7085),
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 30 / pixelRatio, 0, 30 / pixelRatio),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Time: ' + currentReminder!.hour + ':' + currentReminder!.minute,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0c7085),
                                          fontFamily: 'Inter',
                                        )),
                                    Icon(
                                      Icons.watch_later_rounded,
                                      color: Color(0xff0c7085),
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10 / pixelRatio, 0, 20 / pixelRatio),
                                child: SizedBox(
                                  height: 100.0 / pixelRatio,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Location: ' + currentReminder!.location,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0c7085),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10 / pixelRatio, 0, 20 / pixelRatio),
                                child: SizedBox(
                                  height: 100.0 / pixelRatio,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Dosage: ' + currentReminder!.dosage,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0c7085),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Container(
                        //height: 40,
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        decoration: const BoxDecoration(
                            color: Color(0xfffefefe),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10 / pixelRatio, 0, 20 / pixelRatio),
                                child: SizedBox(
                                  height: 100.0 / pixelRatio,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Reminder Type: ' + currentReminder!.type,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0c7085),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
