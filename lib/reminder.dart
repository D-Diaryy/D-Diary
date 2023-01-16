import 'package:cloud_firestore/cloud_firestore.dart';

class Rem{

  final String dateAndTime;
  final String day;
  final String dosage;
  final String hour;
  final String location;
  final String minute;
  final String month;
  final String notes;
  final String title;
  final String type;
  final String year;

  Rem({
    required this.dateAndTime,
    required this.day,
    required this.dosage,
    required this.hour,
    required this.location,
    required this.minute,
    required this.month,
    required this.notes,
    required this.title,
    required this.type,
    required this.year,
  });

  factory Rem.fromDocument(DocumentSnapshot doc) {
    return Rem(
      dateAndTime: doc['DateAndTime'],
      day: doc['Day'],
      dosage: doc['Dosage'],
      hour: doc['Hour'],
      location: doc['Location'],
      minute: doc['Minute'],
      month: doc['Month'],
      notes: doc['Notes'],
      title: doc['Title'],
      type: doc['Type'],
      year: doc['Year'],
    );
  }
}