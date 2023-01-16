import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/home_patient.dart';

import 'database.dart';
import 'home_carer.dart';
import 'notification_controller.dart';

class SplashMedicine extends StatefulWidget {
  const SplashMedicine({Key? key}) : super(key: key);

  @override
  State<SplashMedicine> createState() => _SplashMedicineState();
}

class _SplashMedicineState extends State<SplashMedicine> {
  initState(){
    DatabaseService.hello();
    //AwesomeNotifications().dismiss(notifDetails!.id!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
    return Scaffold(
      // backgroundColor: Colors.cyan.shade900,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/wave_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0 / pixelRatio, 0, 0),
                child: Text(
                  notifDetails!.to.toString(),//DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
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
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 50 / pixelRatio, 0, 0),
                child: Text(
                  notifDetails!.time.toString(),//DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 100.0 / pixelRatio,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffec8420),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20 / pixelRatio, 0, 0),
                child: Text(
                  notifDetails!.nTitle != null ? notifDetails!.nTitle.toString() : "This is a Title",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 65.0 / pixelRatio,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffec8420),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20 / pixelRatio, 0, 0),
                child: Text(
                  notifDetails!.nNotes != null ? notifDetails!.nNotes.toString() : "This is a Notes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0 / pixelRatio,
                    color: const Color(0xffec8420),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 150 / pixelRatio, 0.0, 0.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/MedicineSplash.png',
                  width: 400/pixelRatio,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 100 / pixelRatio, 0, 100 / pixelRatio),
                child: Text(
                  "Dosage : " + notifDetails!.nDosage.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 55.0 / pixelRatio,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffffffff),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  height: 150 / pixelRatio,
                  width: 300 / pixelRatio,
                  decoration: BoxDecoration(
                    color: const Color(0xffec8420),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async{
                        //await AndroidAlarmManager.oneShot(Duration(seconds: 1),1000,DatabaseService.Snooze);
                        DatabaseService.Snooze();
                        if(currentUser!.type){
                          await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('reminders').doc(notifDetails!.docId).delete();
                        }else{
                          await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminders').doc(notifDetails!.docId).delete();
                        }
                        currentUser!.type ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer())) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient()));
                      },
                      child: Text(
                        'DONE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                        backgroundColor: const Color(0xffec8420),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 150 / pixelRatio,
                  width: 350 / pixelRatio,
                  decoration: BoxDecoration(
                    color: const Color(0xffec8420),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async{
                        DatabaseService.Snooze();
                        await DatabaseService(uid: "").ScheduleNotif(DateTime.now().add(Duration(minutes: 5)), notifDetails!.nTitle, notifDetails!.id, notifDetails!.nType,notifDetails!.toCode);
                        currentUser!.type ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer())) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient()));
                      },
                      child: Text(
                        'SNOOZE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                        primary: const Color(0xffec8420),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Center(
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(0, 150 / pixelRatio, 0, 0),
            //     child: Text(
            //       'SNOOZE',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         decoration: TextDecoration.underline,
            //         fontSize: 50.0 / pixelRatio,
            //         fontWeight: FontWeight.w500,
            //         color: const Color(0xffffffff),
            //         fontFamily: 'Inter',
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
