import 'package:cloud_firestore/cloud_firestore.dart';

class Stat{

  final int carerCount;
  final int patientCount;

  Stat({
    required this.carerCount,
    required this.patientCount
  });

  factory Stat.fromDocument(DocumentSnapshot doc) {
    return Stat(
      carerCount: doc['carerCount'],
      patientCount: doc['patientCount'],
    );
  }
}