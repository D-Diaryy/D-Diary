import 'package:flutter/material.dart';

import 'home_carer.dart';
//change to add some info first
class AccountCreated extends StatefulWidget {
  const AccountCreated({Key? key}) : super(key: key);

  @override
  State<AccountCreated> createState() => _AccountCreatedState();
}

class _AccountCreatedState extends State<AccountCreated> {

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      backgroundColor: const Color(0xffede2d8),
      body: ElevatedButton(
          onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer())); },
          child: Text(
            'Congratulations!\n\nYou have successfully created an account.\n\nClick anywhere to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 60.0 / pixelRatio,
              fontWeight: FontWeight.bold,
              color: const Color(0xff093f5c),
              fontFamily: 'Inter',
            ),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(MediaQuery.of(context).size.height),
            backgroundColor: const Color(0xffede2d8),
          ),
        ),
    );
  }
}

