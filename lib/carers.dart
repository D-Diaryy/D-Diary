import 'package:cloud_firestore/cloud_firestore.dart';

class Carers{

  final String userID;
  final int carerCnt;

  Carers({
    required this.userID,
    required this.carerCnt,
  });

  factory Carers.fromDocument(DocumentSnapshot doc) {
    return Carers(
      userID: doc['UID'],
      carerCnt: doc['Carer Count'],
    );
  }
}