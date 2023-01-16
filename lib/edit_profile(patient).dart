import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:patient_app/database.dart';
import 'package:patient_app/main.dart';

import 'create_notif.dart';
import 'home_patient.dart';
import 'utils.dart';

class EditProfilePatient extends StatefulWidget {
  const EditProfilePatient({Key? key}) : super(key: key);

  @override
  State<EditProfilePatient> createState() => _EditProfilePatientState();
}

class _EditProfilePatientState extends State<EditProfilePatient> {
  final formKey = GlobalKey<FormState>();
  var fullNameController = TextEditingController();
  var nickNameController = TextEditingController();
  var addressController = TextEditingController();
  var birthdateController = TextEditingController();
  var ageController = TextEditingController();
  var contactController = TextEditingController();
  var stageController = TextEditingController();
  var sdcontroller = TextEditingController();
  late File _imageFile;
  final picker = ImagePicker();
  final DatabaseService storage = DatabaseService(uid: '1');
  var datechoice = currentUser!.bday;

  @override
  void dispose() {
    fullNameController.dispose();
    nickNameController.dispose();
    addressController.dispose();
    birthdateController.dispose();
    ageController.dispose();
    contactController.dispose();
    stageController.dispose();

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
  var selectedValue = currentUser!.dementiaStage;
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });

    await uploadImageToFirebase(MyApp.navigatorKey.currentContext!);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditProfilePatient()));
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = Path.basename(_imageFile.path);
    firebase_storage.Reference firebaseStorageref = firebase_storage.FirebaseStorage.instance.ref().child(currentUser!.userID + '/profile/$fileName');
    firebase_storage.UploadTask uploadTask = firebaseStorageref.putFile(_imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((value) async {
      await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(currentUser!.userID).update({
        'Profile Picture': value,
      });
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'Profile Picture': value,
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2: null;
    return Scaffold(
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
                  onTap: () { Navigator.pop(context); },
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 50 / pixelRatio, 0, 0),
                  child: Text(
                    'Edit My Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 60.0 / pixelRatio,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffec8420),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 40 / pixelRatio, 32.0, 0.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(currentUser!.profilePic) as ImageProvider,
                  radius: 175/pixelRatio,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: Container(
                  height: 75 / pixelRatio,
                  width: 560 / pixelRatio,
                  decoration: BoxDecoration(
                    color: const Color(0xffec8420),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: pickImage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            color: Color(0xffffffff),
                            size: 35.0 / pixelRatio
                          ),
                          Text(
                            'Change Profile Photo ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30.0 / pixelRatio,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: const Color(0xffec8420),),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: TextField(
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Full Name: ' + currentUser!.fullName,
                    hintStyle: TextStyle(
                      fontSize: 35.0 / pixelRatio,
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
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                child: TextField(
                  controller: nickNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Username: ' + currentUser!.userName,
                    hintStyle: TextStyle(
                      fontSize: 35.0 / pixelRatio,
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
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 30 / pixelRatio, 32.0, 0.0),
                child: TextField(
                  controller: addressController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Address: ' + currentUser!.address,
                    hintStyle: TextStyle(
                      fontSize: 35.0 / pixelRatio,
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
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
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
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 30 / pixelRatio, 32.0, 0.0),
                      child: TextFormField(
                        controller: ageController,
                        textInputAction: TextInputAction.next,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffede2d8),
                          hintText: 'Age: ' + currentUser!.age,
                          hintStyle: TextStyle(
                            fontSize: 35.0 / pixelRatio,
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
                        validator: (value) => value == '' || (value != null && value.length == 2)
                            ? null
                            : 'Enter a valid age!',
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
                      padding: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 13.0),
                      child: Text(
                        'Email Address: ' + currentUser!.emailAdd,
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
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: TextField(
                  controller: contactController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Guardian/Primary Carer Contact Number: ' + currentUser!.contact,
                    hintStyle: TextStyle(
                      fontSize: 35.0 / pixelRatio,
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
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                child: TextField(
                  maxLines: null,
                  maxLength: 100,
                  controller: sdcontroller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffede2d8),
                    hintText: 'Self Description: ' + currentUser!.description,
                    hintStyle: TextStyle(
                      fontSize: 35.0 / pixelRatio,
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
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),

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
                  height: 150 / pixelRatio,
                  width: 350 / pixelRatio,
                  decoration: BoxDecoration(
                    color: const Color(0xffec8420),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: updateProfile,
                      child: Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45.0 / pixelRatio,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(165 / MediaQuery.of(context).devicePixelRatio),
                        primary: const Color(0xffec8420),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                      ),
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

  Future updateProfile() async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateUserData(
          currentUser!.profilePic,
          FirebaseAuth.instance.currentUser!.uid,
          false,
          fullNameController.text.trim() == "" ? currentUser!.fullName : fullNameController.text.trim(),
          currentUser!.emailAdd,
          nickNameController.text.trim() == "" ? currentUser!.userName : nickNameController.text.trim(),
          currentUser!.Password,
          addressController.text.trim() == "" ? currentUser!.address : addressController.text.trim(),
          contactController.text.trim() == "" ? currentUser!.contact : contactController.text.trim(),
          ageController.text.trim() == "" ? currentUser!.age : ageController.text.trim(),
          datechoice == currentUser!.bday ? currentUser!.bday : datechoice,
          currentUser!.code,
          currentUser!.carerCode,
          currentUser!.lat,
          currentUser!.long,
          currentUser!.remCnt,
          currentUser!.remRun,
          stageController.text.trim() == "" ? currentUser!.dementiaStage : selectedValue,
          currentUser!.token,
          currentUser!.activated,
          sdcontroller.text.trim() == "" ?  currentUser!.description : sdcontroller.text.trim(),//todo add selfdescription
          currentUser!.deactTime,
          currentUser!.totalSize,
      );
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData();
      await FirebaseFirestore.instance.collection('carers').doc(currentUser!.carerCode).collection('patients').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'UID': currentUser!.userID,
        'Full Name': currentUser!.fullName,
        'Username': currentUser!.userName,
        'Address' : currentUser!.address,
        'Contact': currentUser!.contact,
        'Age': currentUser!.age,
        'Bday' : currentUser!.bday,
        'Dementia Stage': currentUser!.dementiaStage,
        'description' : currentUser!.description,
      });
      String title = "Your Patient ${currentUser!.userName} change his/her info";
      String body = "Info has been change";
      Notify(title: title, body: body).Carers(null);
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient()));
  }
}
