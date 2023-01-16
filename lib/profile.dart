import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';

import 'edit_profile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late var bottom;
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    MediaQuery.of(context).size.height > 1900 ? bottom = 0 : bottom = 150.0/pixelRatio;
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Container(
        padding: EdgeInsets.only(bottom: 100),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/profilebg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, bottom, 32.0, 0.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(currentUser!.profilePic) as ImageProvider,
                  radius: 200/pixelRatio,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 50 / pixelRatio, 0.0, 0.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 60.0 / pixelRatio,
                      fontWeight: FontWeight.w600,
                      color: Colors.cyan.shade900,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: Container(
                  //width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xffede2d8),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(
                        'Full Name:\n' + currentUser!.fullName,
                        style: TextStyle(
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xffec8420),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffede2d8),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(
                        'Username:\n' + currentUser!.userName,
                        style: TextStyle(
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xffec8420),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffede2d8),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(
                        'Address:\n' + currentUser!.address,
                        style: TextStyle(
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xffec8420),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 5.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffede2d8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            child: Text(
                              'Birthdate:\n' + currentUser!.bday,
                              style: TextStyle(
                                fontSize: 35.0 / pixelRatio,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xffec8420),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 30 / pixelRatio, 32.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffede2d8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            child: Text(
                              'Age:\n' + currentUser!.age,
                              style: TextStyle(
                                fontSize: 35.0 / pixelRatio,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xffec8420),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffede2d8),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(
                        'Email Address:\n' + currentUser!.emailAdd,
                        style: TextStyle(
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xffec8420),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffede2d8),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(
                        'Contact Number:\n' + currentUser!.contact,
                        style: TextStyle(
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xffec8420),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0x00ffffff),
                  shadowColor: Color(0x00ffffff),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 40.0 / pixelRatio, 0.0, 0.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.app_registration,
                        color: Color(0xff893111),
                        size: 130.0 / pixelRatio,
                      ),
                      Text(
                        'Edit About\nMe',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0 / pixelRatio,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff893111),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 100.0 / pixelRatio, 0.0, 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Carer\'s Code: ' + currentUser!.code.toString(),
                    style: TextStyle(
                      fontSize: 40.0 / pixelRatio,
                      fontWeight: FontWeight.w600,
                      color: Colors.cyan.shade900,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
