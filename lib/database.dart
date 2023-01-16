import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:patient_app/patient_uid.dart';
import 'package:patient_app/photo.dart';
import 'package:patient_app/reminder.dart';
import 'package:patient_app/token.dart';

import 'carer.dart';
import 'carers.dart';
import 'patient.dart';
import 'statistics.dart';
import 'user.dart';

Userr? currentUser;
Patient? currentPatient;
Stat? currentStat;
Rem? currentReminder;
Photo? currentPhoto;
Carers? currentCarers;
Carer? currentCarer;
PatientUID? currentPatientUID;
Token? currentToken;
myCarers? myCurrentCarers;
Gallery? myGallery;
bool? activated;
myPatients? myCurrentPatients;

class DatabaseService{
  late String uid;
  DatabaseService({ required this.uid });

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference statisticsCollection = FirebaseFirestore.instance.collection('statistics');
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  Future updateUserData(
      String profilePic,
      String userID,
      bool type,
      String fullName,
      String emailAdd,
      String userName,
      String Password,
      String address,
      String contact,
      String age,
      String bday,
      int code,
      String carerCode,
      double lat,
      double long,
      int remCnt,
      int remRun,
      String dementiaStage,
      String token,
      bool activated,
      String description,
      Timestamp deactTime,
      int totalSize,
      ) async {
    return await userCollection.doc(uid).set({
      'Profile Picture': profilePic,
      'UID': userID,
      'User Type': type,
      'Full Name': fullName,
      'Email': emailAdd,
      'Username': userName,
      'Password': Password,
      'Address' : address,
      'Contact': contact,
      'Age': age,
      'Bday' : bday,
      'Code' : code,
      'Carer Code' : carerCode,
      'Latitude' : lat,
      'Longitude' : long,
      'Reminder Count': remCnt,
      'Reminder Run': remRun,
      'Dementia Stage': dementiaStage,
      'token': token,
      'activated' : activated,
      'description' : description,
      'deactTime' : deactTime,
      'totalSize' : totalSize,
    });
  }
  String createTag(int len) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  }
  sendNotification(String title, String body, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'status': 'done',
      'message': title,
      'body' : body,
    };

    try{
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAtfH946w:APA91bG0mKLHvrgkxuSBM1RiqG0ly4817YZGvYPezWCRVpCvDF_72wLGw5rRQS9b_stH5ceOIOIuXQRI1lbAGlD1Sgopb27Fbc8bDWX0EdcD54mWrN6JnJWCYuQX4oAZjgyPduZaqVD7'
      },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic> {'title': title, 'body': body ,'android_channel_id':'dbfood',"tag" : createTag(3)},
            'priority': 'high',
            'data': data,
            'to': token
          })
      );

      if(response.statusCode != 200){
        print("Error");
      }
    }catch(e){

    }
  }

  Future deleteuser() async {
    if(currentUser!.type == false) {
      await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(currentUser!.userID).update({'activated' : false});
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).update({'activated' : false,"deactTime" : Timestamp.now()});
    }else{
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).update({'activated' : false,"deactTime" : Timestamp.now()});
      //await FirebaseFirestore.instance.collection('patients').doc(currentPatient!.code.toString()).collection('carers').doc(currentUser!.userID).update({'activated' : false});
    }
    //return await userCollection.doc(uid).delete();
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref(currentPatient!.userID + '/photos/$imageName').getDownloadURL();
    return downloadURL;
  }

  Future<String> downloadURLPatient(String imageName) async {
    String downloadURL = await storage.ref(currentUser!.userID + '/photos/$imageName').getDownloadURL();
    return downloadURL;
  }

  Future<firebase_storage.ListResult> listDp() async {
    firebase_storage.ListResult results = await storage.ref(currentUser!.userID + '/profile').listAll();
    results.items.forEach((firebase_storage.Reference ref) { });
    return results;
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref(currentPatient!.userID + '/photos').listAll();
    results.items.forEach((firebase_storage.Reference ref) { });
    return results;
  }

  Future<firebase_storage.ListResult> listFilesPatient() async {
    firebase_storage.ListResult results = await storage.ref(currentUser!.userID + '/photos').listAll();
    results.items.forEach((firebase_storage.Reference ref) { });
    return results;
  }

  Future showReminderDataPatient() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(currentUser!.userID).collection('reminders').doc(currentUser!.remRun.toString()).get();
    currentReminder = Rem.fromDocument(doc);
  }

  Future showReminderData(retDocID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('reminders').doc(retDocID).get();
    currentReminder = Rem.fromDocument(doc);
  }

  Future showReminderData2(retDoc) async {
    //DocumentSnapshot doc = await FirebaseFirestore.instance.collection('carers').doc(currentUser!.code.toString()).collection('patients').doc(currentPatient!.userID).collection('reminders').doc(currentPatient!.remRun.toString()).get();
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminders').doc(retDoc).get();
    currentReminder = Rem.fromDocument(doc);
  }

  Future getReminderCarer() async {

  }

  Future getReminderData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(currentUser!.userID).collection('reminders').doc(currentUser!.remRun.toString()).get();
    currentReminder = Rem.fromDocument(doc);
    await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(currentUser!.userID).collection('reminders').doc(currentUser!.remRun.toString()).delete();
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).update({
      'Reminder Run': currentUser!.remRun + 1,
    });
    this.uid = currentUser!.userID;
    getUserData();
    //await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('notifications').doc(currentReminder!.year + currentReminder!.month + currentReminder!.day + currentReminder!.hour + currentReminder!.minute).set({
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('notifications').add({
      'Title': currentReminder!.title,
    });
  }

  Future getUserData() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    currentUser = Userr.fromDocument(doc);
  }

  Future getPatientData() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    currentPatient = Patient.fromDocument(doc);
  }

  Future getAppStatistics() async {
    DocumentSnapshot doc = await statisticsCollection.doc('statistics').get();
    currentStat = Stat.fromDocument(doc);
  }

  Future getPhotoData(String docName) async {
    DocumentSnapshot doc = await userCollection.doc(currentUser!.userID).collection('gallery').doc(docName).get();
    currentPhoto = Photo.fromDocument(doc);
  }

  Future getPhotoDataTrash(String docName) async {
    DocumentSnapshot doc = await userCollection.doc(currentUser!.userID).collection('trashBin').doc(docName).get();
    currentPhoto = Photo.fromDocument(doc);
  }

  Future getPhotoDataCarer(String docName) async {
    DocumentSnapshot doc = await userCollection.doc(currentPatient!.userID).collection('gallery').doc(docName).get();
    currentPhoto = Photo.fromDocument(doc);
  }

  Future getPhotoDataCarerTrash(String docName) async {
    DocumentSnapshot doc = await userCollection.doc(currentPatient!.userID).collection('trashBin').doc(docName).get();
    currentPhoto = Photo.fromDocument(doc);
  }

  Future getPatientCarers() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('patients').doc(currentPatient!.code.toString()).get();
    currentCarers = Carers.fromDocument(doc);
  }

  Future getPatientCarersPatient() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).get();
    currentCarers = Carers.fromDocument(doc);
  }

  Future getCarerUID(String codePassed) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('carers').doc(codePassed).get();
    currentCarer = Carer.fromDocument(doc);
  }
  /*
  Future getCarerToken(String carerUID) async {userCollection
    DocumentSnapshot doc = await .doc(carerUID).get();
    currentToken = Token.fromDocument(doc);
  }
   */
  Future getPatientUID(String codePassed) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('patients').doc(codePassed).get();
    currentPatientUID = PatientUID.fromDocument(doc);
  }
  
  //Niiko Functions
  Future getCarers() async{
    QuerySnapshot doc = await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).collection('carers').get();
    myCurrentCarers = myCarers.fromDocument(doc);
  }
  Future getOtherCarers(code) async{
    QuerySnapshot doc = await FirebaseFirestore.instance.collection('patients').doc(code).collection('carers').get();
    myCurrentCarers = myCarers.fromDocument(doc);
  }

  Future getPatients() async{
    QuerySnapshot doc = await FirebaseFirestore.instance.collection('carers').doc(currentUser!.code.toString()).collection('patients').get();
    myCurrentPatients = myPatients.fromDocument(doc);
  }

  Future<String> getToken(String? uid) async{
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    //var snapshot = doc.data();
    return doc['token'];
  }

  Future getAlbums() async{
    QuerySnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('gallery').get();
    myGallery = Gallery.getImages(doc);
  }
  static void hello()async{
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1, // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
    await Future.delayed(Duration(seconds: 60));
    await FlutterRingtonePlayer.stop();
  }
  static void Snooze()async{
    await FlutterRingtonePlayer.stop();
  }
  ScheduleNotif(dateTime,title,id,type,to)async{
    String ntitle = "D-Diary Alarm Reminder";
    await currentUser!.type ? ntitle += " for " + to.toString() : null;
    print("Scheduled id " + id.toString());
    DateTime now = DateTime.now();
    int interval = dateTime.runtimeType ==  DateTime ? dateTime.difference(now).inSeconds : dateTime.toDate().difference(now).inSeconds;
    interval < 5 ? interval = 5 : null;
    dateTime.runtimeType ==  DateTime ? null : dateTime = dateTime.toDate();
    String timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: type,
          title: ntitle,
          body: title,
        ),
      schedule: NotificationCalendar(
        day: dateTime.day,
        month: dateTime.month,
        year: dateTime.year,
        hour: dateTime.hour,
        minute: dateTime.minute,
      ),
    );
  }
  
  Future checkReminder() async{
    CollectionReference docRef = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('pending');
    QuerySnapshot doc = await docRef.orderBy("time",descending: false).get();
    doc.docs.forEach((e) async{
      print("command" + e['category']);
      if(DateTime.now().difference((e['dateTime'] as Timestamp).toDate()).inMinutes > 1){
        docRef.doc(e.id).delete();
      }else{

        if(e['category'] == "add"){
          DateTime dt = (e['dateTime'] as Timestamp).toDate();
          await ScheduleNotif(dt,e['title'],e['id'],e['type'],e['to']);
          await docRef.doc(e.id).delete();
        }else if(e['category'] == "delete"){
          print("Notif ${e['id']} has been canceled");
          await AwesomeNotifications().cancel(e["id"]);
          await docRef.doc(e.id).delete();
        }else if(e['category'] == "edit"){
          AwesomeNotifications().cancel(e['id']);
          print("Notif ${e['id']} sched");
          DateTime dt = (e['dateTime'] as Timestamp).toDate();
          await ScheduleNotif(dt,e['title'],e['id'],e['type'],e['to']);
          await docRef.doc(e.id).delete();
        }
      }
    });
  }
  static updateStorageUsage(size,target)async{
    await FirebaseFirestore.instance.collection('users').doc(target!.userID).update(
      {'totalSize':target.totalSize + size}
    );
  }
  static updateStorageUsageDec(size,target)async{
    await FirebaseFirestore.instance.collection('users').doc(target!.userID).update(
        {'totalSize':target!.totalSize - size}
    );
  }
}