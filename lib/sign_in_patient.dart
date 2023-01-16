import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/privacy_policy.dart';
import 'package:patient_app/terms_and_conditions.dart';

import 'constant.dart';
import 'login.dart';
import 'login_home.dart';
import 'utils.dart';

class SignInPatient extends StatefulWidget {
  const SignInPatient({Key? key}) : super(key: key);

  @override
  State<SignInPatient> createState() => _SignInPatientState();
}

class _SignInPatientState extends State<SignInPatient> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final carersCodeController = TextEditingController();
  final addressController = TextEditingController();
  final bdayController = TextEditingController();
  final ageController = TextEditingController();
  final contactController = TextEditingController();
  final dementiaStageConroller = TextEditingController();
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;
  var datechoice = "Birthday";
  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    carersCodeController.dispose();

    super.dispose();
  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Stage 1"),value: "Stage 1"),
      DropdownMenuItem(child: Text("Stage 2"),value: "Stage 2"),
      DropdownMenuItem(child: Text("Stage 3"),value: "Stage 3"),
      DropdownMenuItem(child: Text("Stage 4"),value: "Stage 4"),
      DropdownMenuItem(child: Text("Stage 5"),value: "Stage 5"),
      DropdownMenuItem(child: Text("Not Applicable/Not Diagnosed"),value: "Not Applicable/Not Diagnosed"),
    ];
    return menuItems;
  }
  var selectedValue = "Stage 1";
  bool checkedValue = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    if (!checkedValue) {
      return Colors.red;
    }else{
      return Color(0xffec8420);
    }


  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      // backgroundColor: Colors.cyan.shade900,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 0, 0),
                    child: Container(
                        height: 100 / pixelRatio,
                        width: 100 / pixelRatio,
                        decoration: const BoxDecoration(
                            color: Color(0xff093f5c), shape: BoxShape.circle),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xffede2d8),
                          size: 20,
                        )),
                  ),
                  onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLogin())); },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    'Let\'s get started!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 60.0 / pixelRatio,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 25 / pixelRatio, 0.0, 0.0),
                child: Text(
                  'Create an account as Patient',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0 / pixelRatio,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff0c7085),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Full Name',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) =>
                  name != null && name == '' ? 'Enter your name' : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: userNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (userName) =>
                  userName != null && userName == '' ? 'Enter your username' : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xffec8420),
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 8
                      ? 'Enter min. 8 characters'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xffec8420),
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                  value!=passwordController.text.trim() || value == null
                      ? 'Password Doesn\'t Match! or Empty'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: addressController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Address',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (address) => address == null
                      ? 'Enter a valid Address'
                      : null,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Color(0xffede2d8),
                  ),
                  onPressed: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1920, 1), lastDate: DateTime.now()).then((value){
                      setState(() {
                        datechoice = value!.month.toString() + "/" + value.day.toString() + "/" + value.year.toString();
                        ageController.text = (DateTime.now().difference(value).inDays ~/365).toString();
                      });
                    });

                  },
                  icon: Icon(Icons.cake_outlined,color:Color(0xffec8420)),
                  label: Text(
                    datechoice,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 50.0 / pixelRatio,
                      color: const Color(0xffec8420),
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: ageController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.looks_two_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Age',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (age) =>
                  age == null || double.tryParse(age) == null
                      ? 'Input your valid age'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: contactController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.contact_page_outlined, size: 30, color: const Color(0xffec8420),),
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Guardian/Primary Carer Contact Number',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (contact) =>
                  contact == null || double.tryParse(contact) == null || contact.length > 11
                      ? 'Enter a valid Guardian/Primary Carer Contact Number'
                      : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: TextFormField(
                  controller: carersCodeController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Carer\'s Code',
                    hintStyle: TextStyle(
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color(0xffede2d8)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 4
                      ? 'Enter a valid carer code'
                      : null,
                ),
              ),
              Container(
                child: DropdownButton(
                    value: selectedValue,
                    style: TextStyle(color:Color(0xffec8420),fontSize: 50.0 / pixelRatio),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: Container(
                  height: 150/pixelRatio,
                  width: 350/pixelRatio,
                  decoration: BoxDecoration(
                    color: const Color(0xffec8420),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: signUp,
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 55.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: checkedValue,
                    onChanged: (bool? value) {
                      setState(() {
                        checkedValue = value!;
                      });
                    },
                  ),
                  Text(
                    'By creating an account or continuing to use D-Diary, you\nacknowledge and agree that you have read and',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff0c7085),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'accepted the ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff0c7085),
                      fontFamily: 'Inter',
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Terms and Conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 35.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0c7085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditions())); },
                  ),
                  Text(
                    'and have reviewed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0 / pixelRatio,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff0c7085),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'the ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35.0 / pixelRatio,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff0c7085),
                        fontFamily: 'Inter',
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 35.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff0c7085),
                          fontFamily: 'Inter',
                        ),
                      ),
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy())); },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
                child: Text(
                  'Already have an account as patient?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0 / pixelRatio,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff893111),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 50 / pixelRatio),
                child: GestureDetector(
                  child: Text(
                    'Sign in.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 50.0 / pixelRatio,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff893111),
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login())); },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (!checkedValue) {
      Utils.showSnackBar('Please Agree to terms and condition');
      return;
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await DatabaseService(uid: 'Null').getAppStatistics();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      String? token = await FirebaseMessaging.instance.getToken();
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateUserData(
            defaultpic,
            FirebaseAuth.instance.currentUser!.uid,
            false,
            fullNameController.text.trim(),
            emailController.text.trim(),
            userNameController.text.trim(),
            passwordController.text.trim(),
            addressController.text.trim(),
            contactController.text.trim(),
            ageController.text.trim(),
            datechoice,
            currentStat!.patientCount + 1,
            carersCodeController.text.trim(),
            0.0,
            0.0,
            0,
            0,
            selectedValue,
            token!,
            true,
            "",
            Timestamp.fromDate(DateTime.now().add(Duration(days: 365*5))),
            0,
      );
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
      await FirebaseFirestore.instance.collection('statistics').doc('statistics').update({
        'patientCount': currentStat!.patientCount + 1,
      });
      await FirebaseFirestore.instance.collection('carers').doc(carersCodeController.text.trim()).collection('patients').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'Profile Picture': defaultpic,
        'UID': currentUser!.userID,
        'User Type': currentUser!.type,
        'Full Name': currentUser!.fullName,
        'Email': currentUser!.emailAdd,
        'Username': currentUser!.userName,
        'Password': currentUser!.Password,
        'Address' : currentUser!.address,
        'Contact': currentUser!.contact,
        'Age': currentUser!.age,
        'Bday' : currentUser!.bday,
        'Code' : currentUser!.code,
        'Carer Code' : currentUser!.carerCode,
        'Latitude' : currentUser!.lat,
        'Longitude' : currentUser!.long,
        'Reminder Count' : currentUser!.remCnt,
        'Reminder Run' : currentUser!.remRun,
        'Dimentia Stage' : currentUser!.dementiaStage,
        'activated' : true,
        'token': currentUser!.token,
        }, SetOptions(merge: true));
      await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).set({
        'UID': currentUser!.userID,
        'Carer Count': 1,
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getCarerUID(currentUser!.carerCode);
      await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).collection('carers').doc(currentCarer!.userID).set({
        'Carer Code': currentUser!.carerCode,
        'activated' : 'true',
      });
      await DatabaseService(uid: '').getToken(currentCarer!.userID);
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

