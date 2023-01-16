import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';

class Notify{
  final String title;
  final String body;
  String date = '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}-${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
  Notify({required this.title,required this.body});
  sendAlarm(data,e)async{
    await FirebaseFirestore.instance.collection('users').doc(e).collection('pending').add(data);
  }
  Patient(patientID,data) async {
    DatabaseService db = DatabaseService(uid: currentUser!.userID);
    String? curToken = await db.getToken(patientID);
    FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('notifications').add({
      "title" : title,
      "body" : body,
      "date" : date,
      //"date" : dateTime == null ? date : dateTime,
    });
    curToken != "" ? await db.sendNotification(title,body,curToken) : null;
    data != null ? await sendAlarm(data,currentPatient!.userID) : null;
  }
  Patients(dateTime)async{
    DatabaseService db = DatabaseService(uid: currentUser!.userID);
    await db.getPatients();
    myCurrentPatients!.patients.forEach((e) async {
      String? curToken = await db.getToken(e);
      FirebaseFirestore.instance.collection('users').doc(e).collection('notifications').add({
        "title" : title,
        "body" : body,
        "date" : date,
      });
      curToken != "" ? await db.sendNotification(title,body,curToken) : null;
    });
  }
  Carer()async{
    DatabaseService db = await DatabaseService(uid: currentUser!.userID);
    String token = await db.getToken(currentCarer!.userID).toString();
    FirebaseFirestore.instance.collection('users').doc(currentCarer!.userID).collection('notifications').add({
      "title" : title,
      "body" : body,
      "date" : date,
    });
    token != "" ? db.sendNotification(title,body,token) : null;
  }
  Carers(data)async{
    DatabaseService db = await DatabaseService(uid: currentUser!.userID);
    await db.getCarers();
    myCurrentCarers!.carers.forEach((e) async {
      await FirebaseFirestore.instance.collection('users').doc(e).collection('notifications').add({
        "title" : title,
        "body" : body,
        "date" : date,
      });
      var token = await db.getToken(e);
      token != "" ? await db.sendNotification(title,body,token.toString()) : null;
      data != null ? await sendAlarm(data,e) : null;
    });

  }
  OtherCarers(data,patientCode)async{
    DatabaseService db = await DatabaseService(uid: currentUser!.userID);
    await db.getOtherCarers(patientCode);
    myCurrentCarers!.carers.forEach((e) async {
      if(currentUser!.userID != e){
        await FirebaseFirestore.instance.collection('users').doc(e).collection('notifications').add({
          "title" : title,
          "body" : body,
          "date" : DateTime.now(),
        });
        var token = await db.getToken(e);
        token != "" ? await db.sendNotification(title,body,token.toString()) : null;
        data != null ? await sendAlarm(data,e) : null;
      };
    });

  }
}