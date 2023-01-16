import 'package:cloud_firestore/cloud_firestore.dart';

class Token{

  final String token;

  Token({
    required this.token,
  });

  factory Token.fromDocument(DocumentSnapshot doc) {
    return Token(
      token: doc['token'],
    );
  }
}