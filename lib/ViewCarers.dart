import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/utils.dart';

import 'about_me(patient).dart';
import 'database.dart';

class ViewCarers extends StatefulWidget {
  const ViewCarers({Key? key}) : super(key: key);

  @override
  State<ViewCarers> createState() => _ViewCarersState();
}

class _ViewCarersState extends State<ViewCarers> {
  final patientCodeController = TextEditingController();
  @override
  void initState(){
    getCarerList();
    super.initState();
  }
  @override
  void dispose() {
    patientCodeController.dispose();

    super.dispose();
  }
  List<String> carerCodeList = [];
  getCarerList() async {
    QuerySnapshot carerList = await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).collection('carers').get().then((value) => value);
    carerList.docs.forEach((e) {
      carerCodeList.add(e.id);
    });
  }

  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final retDoc = snapshot.docs[index];
        if(carerCodeList.contains(retDoc.id)){
          if(retDoc['activated']){
            return Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 5),
              child: Text(
                retDoc['Code'].toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff893111),
                  fontFamily: 'Inter',
                ),
              ),
            );
          }else{
            return Container();
          }
        }else{
          return Container();
        }

        //   ListTile(
        //   title: Text(doc['UID'])
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Column(
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AboutMePatient())); },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'My Carer/s',
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 40, 0, 0),
              child: Text(
                'CARERS CODE LIST',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0 / pixelRatio,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff893111),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(
                child: _buildList(snapshot.data!),
              );
            },
          ),
          Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                    child: Text('+ Add New Carer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 60.0 / pixelRatio,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          shadows: const [
                            Shadow(color: Color(0xffec8420), offset: Offset(0, -3))
                          ],
                          color: Colors.transparent,
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xffec8420),
                          decorationThickness: 2,
                        )),
                  ),
                  onTap: () {
                    openDialog();
                  },
                ),
              )
          )
        ],
      ),
    );
  }
  Future openDialog() => showDialog(
    context: context,
    builder: (context) =>AlertDialog(
      title: Text('Add New Carer'),
      content: TextField(
        controller: patientCodeController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter Carer Code',
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              DocumentSnapshot carers = await FirebaseFirestore.instance.collection("carers").doc(patientCodeController.text.trim()).get();
              if(carers.exists){
                try{
                  await FirebaseFirestore.instance.collection('carers').doc(patientCodeController.text.trim()).collection('patients').doc(currentUser?.userID).set({
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
                    'activated' : currentUser!.activated,
                  });
                  await DatabaseService(uid: '').getCarerUID(patientCodeController.text.trim());
                  await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).collection('carers').doc(currentCarer!.userID).set({
                    'Carer Code': patientCodeController.text.trim(),
                    'activated' : true
                  });
                  await DatabaseService(uid: '').getPatientCarersPatient();
                  await FirebaseFirestore.instance.collection('patients').doc(currentUser!.code.toString()).update({
                    'Carer Count': currentCarers!.carerCnt + 1,
                  });
                } on FirebaseAuthException catch(e) {
                  print(e);

                  Utils.showSnackBar(e.message);
                }
              }else{
                Utils.showSnackBar("That Carer doesn't exist!");
              }

              Navigator.of(context).pop();
            },
            child: Text('Submit')
        ),
      ],
    ),
  );
}
class CarerInfo{
  String? activated;
  late bool check;
   getCarerInfo(uid)async{
    final status = await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data());
    checked(status!['activated']);
  }
  checked(x){
     if(x){
       check = true;
     }
  }


}
