import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/utils.dart';
import 'create_notif.dart';
import 'database.dart';
import 'home_patient.dart';
import 'my_reminders(patient).dart';

class AddReminderPatient extends StatefulWidget {
  final docId;
  AddReminderPatient({this.docId});

  @override
  State<AddReminderPatient> createState() => _AddReminderPatientState();
}

class _AddReminderPatientState extends State<AddReminderPatient> {
  DateTime now = new DateTime.now();
  late DateTime date = DateTime(now.year, now.month, now.day);
  late DateTime dateChoice = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final notesController = TextEditingController();
  final locationController = TextEditingController();
  final dosageController = TextEditingController();
  late bool editInit = false;
  late int alarmId;
  String type = "Personal";

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2: null;
    @override
    @override
    void dispose() {
      titleController.dispose();
      notesController.dispose();
      locationController.dispose();
      dosageController.dispose();
      super.dispose();
    }
    return FutureBuilder(
      future: editReminder(widget.docId),
        builder: (BuildContext context,snapshot){
          final hours = dateChoice.hour.toString().padLeft(2, '0');
          final minutes = dateChoice.minute.toString().padLeft(2, '0');
          return snapshot.hasData ? Scaffold(
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(32, 100 / pixelRatio, 0, 0),
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
                        onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyReminders())); },
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 100 / pixelRatio, 32, 0),
                          child: Container(
                              height: 100 / pixelRatio,
                              width: 100 / pixelRatio,
                              decoration: const BoxDecoration(
                                  color: Color(0xff093f5c), shape: BoxShape.circle),
                              child: const Icon(
                                Icons.home,
                                color: Color(0xffede2d8),
                                size: 20,
                              )),
                        ),
                        onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50 / pixelRatio, 0, 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 250 / pixelRatio,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Color(0xff093f5c),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyReminders())); },
                                  ),
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTap: createReminder,
                                  )
                                ]),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Container(
                                //height: 90,
                                width: MediaQuery.of(context).size.width * 1,
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                decoration: const BoxDecoration(
                                    color: Color(0xfffefefe),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0 / pixelRatio, 0, 0 / pixelRatio),
                                        child: SizedBox(
                                          //height: 100.0 / pixelRatio,
                                          child: TextField(
                                            controller: titleController,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color(0xfffefefe),
                                              hintText: 'Title',
                                              hintStyle: TextStyle(
                                                fontSize: 40.0 / pixelRatio,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0x4f0c7085),
                                                fontFamily: 'Inter',
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0 / pixelRatio, 0, 0 / pixelRatio),
                                        child: SizedBox(
                                          //height: 100.0 / pixelRatio,
                                          child: TextField(
                                            maxLength: 50,
                                            maxLines: null,
                                            controller: notesController,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color(0xfffefefe),
                                              hintText: 'Notes',
                                              hintStyle: TextStyle(
                                                fontSize: 40.0 / pixelRatio,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0x4f0c7085),
                                                fontFamily: 'Inter',
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                    ]
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Container(
                                //height: 160,
                                width: MediaQuery.of(context).size.width * 1,
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                decoration: const BoxDecoration(
                                    color: Color(0xfffefefe),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 30 / pixelRatio, 0, 30 / pixelRatio),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Date: ${dateChoice.month}/${dateChoice.day}/${dateChoice.year}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0c7085),
                                                  fontFamily: 'Inter',
                                                )),
                                            GestureDetector(
                                                child: Icon(
                                                  Icons.calendar_month,
                                                  color: Color(0xff0c7085),
                                                  size: 20,
                                                ),
                                                onTap: () async {
                                                  final dateReceived = (await pickDate())!;
                                                  if (dateReceived == null) return;

                                                  final newDateTime = DateTime(dateReceived.year, dateReceived.month, dateReceived.day, dateChoice.hour, dateChoice.minute);

                                                  setState(() => dateChoice = newDateTime);
                                                }
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 30 / pixelRatio, 0, 30 / pixelRatio),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Time: $hours:$minutes',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0c7085),
                                                  fontFamily: 'Inter',
                                                )),
                                            GestureDetector(
                                                child: Icon(
                                                  Icons.watch_later_rounded,
                                                  color: Color(0xff0c7085),
                                                  size: 20,
                                                ),
                                                onTap: () async {
                                                  final time = (await pickTime())!;
                                                  if (time == null) return;

                                                  final newDateTime = DateTime(dateChoice.year, dateChoice.month, dateChoice.day, time.hour, time.minute);

                                                  setState(() => dateChoice = newDateTime);
                                                }
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 10 / pixelRatio, 0, 20 / pixelRatio),
                                        child: SizedBox(
                                          height: 100.0 / pixelRatio,
                                          child: TextField(
                                            controller: locationController,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color(0xfffefefe),
                                              hintText: 'Location: (Optional)',
                                              hintStyle: TextStyle(
                                                fontSize: 40.0 / pixelRatio,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0x4f0c7085),
                                                fontFamily: 'Inter',
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 10 / pixelRatio, 0, 20 / pixelRatio),
                                        child: SizedBox(
                                          height: 100.0 / pixelRatio,
                                          child: TextField(
                                            controller: dosageController,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color(0xfffefefe),
                                              hintText: 'Dosage: (Optional)',
                                              hintStyle: TextStyle(
                                                fontSize: 40.0 / pixelRatio,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0x4f0c7085),
                                                fontFamily: 'Inter',
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Container(
                                //height: 140,
                                width: MediaQuery.of(context).size.width * 1,
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                decoration: const BoxDecoration(
                                    color: Color(0xfffefefe),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0.0, 30 / pixelRatio, 0.0, 30 / pixelRatio),
                                        child: const Text('Reminder Type:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff0c7085),
                                              fontFamily: 'Inter',
                                            )),
                                      ),
                                      Divider(color: Color(0xff0c7085), thickness: 2, height: 0,),
                                      SizedBox(
                                        child: RadioListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Color(0xff0c7085),
                                          title: Align(
                                            alignment: Alignment(-1.1, 0),
                                            child: Text(
                                              "Personal",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Inter"
                                              ),
                                            ),
                                          ),
                                          value: "Personal",
                                          groupValue: type,
                                          onChanged: (value){
                                            setState(() {
                                              type = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        child: RadioListTile(
                                          activeColor: Color(0xff0c7085),
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          title: Align(
                                            alignment: Alignment(-1.1, 0),
                                            child: Text(
                                              "Check Up",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Inter"
                                              ),
                                            ),
                                          ),

                                          value: "Check Up",
                                          groupValue: type,
                                          onChanged: (value){
                                            setState(() {
                                              type = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        child: RadioListTile(
                                          activeColor: Color(0xff0c7085),
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          title: Align(
                                            alignment: Alignment(-1.1, 0),
                                            child: Text(
                                              "Medicine Intake",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Inter"
                                              ),
                                            ),
                                          ),

                                          value: "Medicine Intake",
                                          groupValue: type,
                                          onChanged: (value){
                                            setState(() {
                                              type = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ) : Center(child: CircularProgressIndicator());
        });
  }

  Future<DateTime?> pickDate() => showDatePicker(
    context: context,
    initialDate: date,
    firstDate: DateTime.now(),
    lastDate: DateTime(date.year + 1),
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: dateChoice.hour, minute: dateChoice.minute),
  );

  String generateRandomString(int len) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        len, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
  Future createReminder() async{
    DatabaseService db = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    await db.getUserData();
    int remCnt = currentUser!.remCnt+1;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    String tempDocId;
    widget.docId == null ? tempDocId = await generateRandomString(10) : tempDocId = widget.docId;
    await db.getUserData();
    DateTime dateChoicee = DateTime(dateChoice.year,dateChoice.month,dateChoice.day,dateChoice.hour,dateChoice.minute,DateTime.now().second);
    try {
      Map<String,Object> data = {
        'DateAndTime': '${dateChoice.month}/${dateChoice.day}/${dateChoice.year}-${dateChoice.hour.toString().padLeft(2, '0')}:${dateChoice.minute.toString().padLeft(2, '0')}',
        'Title': titleController.text.trim(),
        'Notes': notesController.text.trim(),
        'Month': '${dateChoice.month}',
        'Day': '${dateChoice.day}',
        'Year': '${dateChoice.year}',
        'Hour': '${dateChoice.hour}',
        'Minute': '${dateChoice.minute}',
        'Location': locationController.text.trim(),
        'Dosage': dosageController.text.trim(),
        'Type' : type,
        'Alarm ID' : widget.docId == null ? remCnt:alarmId,
        'picture' : currentUser!.profilePic
      };
      DocumentReference doc = FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminders').doc(tempDocId);
      DocumentReference doc1 =  FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminderss').doc(tempDocId);
      widget.docId == null ? await doc.set(data) : await doc.update(data);
      widget.docId == null ? await doc1.set(data) : await doc1.update(data);
      widget.docId == null ? await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'Reminder Count': remCnt,
      }) : null;
      // Add Notification
      if(widget.docId != null){
        String title = "Your Patient ${currentUser!.userName} edit a reminder";
        String body = "${titleController.text.trim()} has been edited.";
        Notify(title: title, body: body).Carers(
            {
              'dateTime':dateChoicee,
              'title' : titleController.text.trim(),
              'id' : alarmId,
              'type' : type,
              'category' : "edit",
              'to' : currentUser!.code.toString(),
              'time' : DateTime.now()
            }
        );
        await AwesomeNotifications().cancel(alarmId);
        await db.ScheduleNotif(dateChoicee, titleController.text.trim(), alarmId, type,currentUser!.code.toString());
      }else{
        String title = "Your Patient ${currentUser!.userName} added a reminder titled ${titleController.text.trim()}";
        String body = "A reminder has been added.";
        Notify(title: title, body: body).Carers(
            {
              'dateTime':dateChoicee,
              'title' : titleController.text.trim(),
              'id' : remCnt,
              'type' : type,
              'category' : "add",
              'to' : currentUser!.code.toString(),
              'time' : DateTime.now()
            }
        );
        await db.ScheduleNotif(dateChoicee, titleController.text.trim(), remCnt, type,currentUser!.code.toString());
      }
    } on FirebaseAuthException catch(e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyReminders()));
  }

  editReminder(docId) async{
    if(docId == null){
      return 1;
    }
    if(editInit){
      return 1;
    }
    editInit = true;
    Reminderr reminder = new Reminderr();
    final remRef = await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('reminders').doc(docId).get();
    await reminder.setRem(remRef);
    titleController.text = reminder.title;
    notesController.text = reminder.notes;
    locationController.text = reminder.location;
    dosageController.text = reminder.dosage;
    dateChoice = await DateTime(int.parse(reminder.year), int.parse(reminder.month), int.parse(reminder.day), int.parse(reminder.hour), int.parse(reminder.minute));
    alarmId = reminder.alarmId;
    type = reminder.type;
    //await Future.delayed(Duration(seconds: 1));
    print(dateChoice.hour);
    return 1;
  }
}

class Reminderr{
  late final dateTime;
  late final title;
  late final notes;
  late final month;
  late final day;
  late final year;
  late final hour;
  late final minute;
  late final location;
  late final dosage;
  late final type;
  late final alarmId;
  setRem(docId){
    dateTime = docId['DateAndTime'];
    title = docId['Title'];
    notes = docId['Notes'];
    month = docId['Month'];
    day = docId['Day'];
    year = docId['Year'];
    hour = docId['Hour'];
    minute = docId['Minute'];
    location = docId['Location'];
    dosage = docId['Dosage'];
    type = docId['Type'];
    alarmId = docId['Alarm ID'];
  }
}