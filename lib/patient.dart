import 'package:cloud_firestore/cloud_firestore.dart';

class Patient{

  final String userID;
  final bool type;
  final String fullName;
  final String emailAdd;
  final String userName;
  final String Password;
  final String address;
  final String contact;
  final String age;
  final String bday;
  final int code;
  final String carerCode;
  final double lat;
  final double long;
  final int remCnt;
  final int remRun;
  final String dementiaStage;
  final String profilePic;
  final bool activated;
  final String description;
  final int totalSize;
  Patient({
    required this.userID,
    required this.type,
    required this.fullName,
    required this.emailAdd,
    required this.userName,
    required this.Password,
    required this.address,
    required this.contact,
    required this.age,
    required this.bday,
    required this.code,
    required this.carerCode,
    required this.lat,
    required this.long,
    required this.remCnt,
    required this.remRun,
    required this.dementiaStage,
    required this.profilePic,
    required this.activated,
    required this.description,
    required this.totalSize,
  });

  factory Patient.fromDocument(DocumentSnapshot doc) {
    return Patient(
      userID: doc['UID'],
      type: doc['User Type'],
      fullName: doc['Full Name'],
      emailAdd: doc['Email'],
      userName: doc['Username'],
      Password: doc['Password'],
      address: doc['Address'],
      contact: doc['Contact'],
      age: doc['Age'],
      bday: doc['Bday'],
      code: doc['Code'],
      carerCode: doc['Carer Code'],
      lat: doc['Latitude'],
      long: doc['Longitude'],
      remCnt: doc['Reminder Count'],
      remRun: doc['Reminder Run'],
      dementiaStage: doc['Dementia Stage'],
      profilePic: doc['Profile Picture'],
      activated: doc['activated'],
      description: doc['description'],
      totalSize: doc['totalSize'],
    );
  }
}