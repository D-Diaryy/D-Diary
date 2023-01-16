import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';

import 'albums(patient).dart';
import 'constant.dart';
import 'home_patient.dart';
import 'image_view2(patient).dart';

class RecentlyDeletedPatient extends StatefulWidget {
  const RecentlyDeletedPatient({Key? key}) : super(key: key);

  @override
  State<RecentlyDeletedPatient> createState() => _RecentlyDeletedPatientState();
}

class _RecentlyDeletedPatientState extends State<RecentlyDeletedPatient> {
  final DatabaseService storage = DatabaseService(uid: '1');

  Widget _buildList(QuerySnapshot snapshot) {
    return GridView.builder(
        itemCount: snapshot.docs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0
        ),
        itemBuilder: (context, index) {
          final retDoc = snapshot.docs[index];
          if(retDoc['type'] == ".mp4"){
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(playvideofile),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 200,
                height: 200,
              ),
              onTap: (){

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageViewPatient2(category: "video",doc:retDoc)));
              },
            );
          }else if(retDoc['type'] == ".mp3"){
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(playaudiofile),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 200,
                height: 200,
              ),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageViewPatient2(category: "audio",doc:retDoc)));
              } ,
            );
          }else{
            return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(7.5),
                  width: 185,
                  height: 185,
                  child: Image.network(
                    retDoc['Image Link'],
                    fit: BoxFit.cover,
                  ),
                ),
                onTap:()async{
                  await DatabaseService(uid: '').getPhotoDataTrash(retDoc.id);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageViewPatient2(category: "image",doc: retDoc,)));
                }
            );
          }
          //return Text(snapshot.data!.items[index].name);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyAlbum())); },
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 32, 0),
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
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                'Recently Deleted',
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('trashBin').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(
                  child: _buildList(snapshot.data!)
              );
            },
          ),
        ],
      ),
    );
  }
}
