import 'package:cloud_firestore/cloud_firestore.dart';

class PatientUID{

  final String userID;

  PatientUID({
    required this.userID,
  });

  factory PatientUID.fromDocument(DocumentSnapshot doc) {
    return PatientUID(
      userID: doc['UID'],
    );
  }
}