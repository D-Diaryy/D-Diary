import 'package:cloud_firestore/cloud_firestore.dart';

class Carer{

  final String userID;

  Carer({
    required this.userID,
  });

  factory Carer.fromDocument(DocumentSnapshot doc) {
    return Carer(
      userID: doc['UID'],
    );
  }
}

class myCarers{
  final List carers;

  myCarers({
    required this.carers,
  });

  factory myCarers.fromDocument(QuerySnapshot doc) {
    List myList = [];
    doc.docs.forEach((e) {
      myList.add(e.id);
    });
    return myCarers(
      carers: myList,
    );
  }
}

class myPatients{
  final List patients;

  myPatients({
    required this.patients,
  });

  factory myPatients.fromDocument(QuerySnapshot doc) {
    List myList = [];
    doc.docs.forEach((e) {
      myList.add(e.id);
    });
    return myPatients(
      patients: myList,
    );
  }
}