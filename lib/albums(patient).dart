import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path/path.dart' as Path;
import 'package:path/path.dart' as p;
import 'package:patient_app/create_notif.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/recently_deleted_patient.dart';
import 'package:patient_app/utils.dart';

import 'constant.dart';
import 'home_patient.dart';
import 'image_view(patient).dart';

class MyAlbum extends StatefulWidget {
  const MyAlbum({Key? key}) : super(key: key);

  @override
  State<MyAlbum> createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  final DatabaseService storage = DatabaseService(uid: '1');
  double progress = 0.0;
  doUpload(file,size)async{
    String fileName = Path.basename(file.path);
    firebase_storage.Reference firebaseStorageref = firebase_storage.FirebaseStorage.instance.ref().child(currentUser!.userID + '/${p.extension(file.path)}/$fileName');
    firebase_storage.UploadTask uploadTask = firebaseStorageref.putFile(file);
    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        showDialog(
            barrierDismissible : false,
            context: context,
            builder: (context) {
              return  StatefulBuilder(
                  builder: (context, setState) {
                    return Dialog(
                      child: Container(
                        height: 200.0,
                        width: 200.0,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 375),
                          child: LiquidCircularProgressIndicator(
                            value: progress / 100,
                            valueColor: AlwaysStoppedAnimation(Color(0xffec8420)),
                            backgroundColor: Colors.white,
                            direction: Axis.vertical,
                            center: Text(
                              "$progress%",
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
        );
        progress = ((event.bytesTransferred.toDouble() /
            event.totalBytes.toDouble()) *
            100)
            .roundToDouble();

        if (progress == 100) {
          event.ref
              .getDownloadURL();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyAlbum()));
        }
      });
    });
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      DatabaseService.updateStorageUsage(size,currentUser);
    });
    String tempLink = await taskSnapshot.ref.getDownloadURL() as String;
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('gallery').add({
      'Image Link': tempLink,
      'Title': 'Title of Media',
      'Description': 'Description',
      'ID' : '',
      'type' : p.extension(file.path),
    });
    String? title = 'Patient ${currentUser!.userName} added a file';
    String? body = 'A file has been added';
    Notify(title: title,body: body).Carers(null);
  }
  void SelectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: ['jpg','png','jpeg','mp4','mp3'],
        type: FileType.custom
    );
    if(result != null){
      List<File> files = result.paths.map((path) => File(path!)).toList();
      files.forEach((e) async {
        int sizeInBytes = e.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if(currentUser!.totalSize + e.lengthSync() > 5368709120){
          String title = "Patient ${currentUser!.fullName} is on file size limit";
          String body = "Patient ${currentUser!.fullName} is trying to upload.";
          Utils.showSnackBar("Exceeded limit cannot add more files.");
          Notify(title: title,body: body).Carers(null);
        }else{
          if(p.extension(e.path) == ".mp4"){
            if(sizeInMb < 200){
              await doUpload(e,e.lengthSync());
            }else{
              String title = "Patient ${currentUser!.fullName} try to upload a large video.";
              String body = "Size of ${Path.basename(e.path)} video exceeded 200mb quota.";
              Utils.showSnackBar(title);
              Notify(title: title,body: body).Carers(null);
            }
          }else{
            if(sizeInMb < 25){
              await doUpload(e,e.lengthSync());
            }else{
              String title = "Patient ${currentUser!.fullName} try to upload a large file.";
              String body = "Size of ${Path.basename(e.path)} video exceeded 25mb quota.";
              Utils.showSnackBar(title);
              Notify(title: title,body: body).Carers(null);
            }
          }
        }
      });
    }
  }

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
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(playvideofile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: (){

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageViewPatient(category: "video",doc:retDoc)));
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageViewPatient(category: "audio",doc:retDoc)));
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
              onTap: () async {
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('gallery').doc(retDoc.id).update({
                  'ID' : retDoc.id,
                });
                await DatabaseService(uid: '').getPhotoData(retDoc.id);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageViewPatient(category: "image",doc:retDoc)));
              },
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient())); },
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
                'My Album',
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
            stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.userID).collection('gallery').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(
                  child: _buildList(snapshot.data!)
              );
            },
          ),
          // FutureBuilder(
          //   future: storage.listFilesPatient(),
          //   builder: (BuildContext context,
          //       AsyncSnapshot<firebase_storage.ListResult> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          //       return Expanded(child: _buildList(snapshot));
          //     }
          //     if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
          //       return CircularProgressIndicator();
          //     }
          //     return Expanded(child: Container());
          //   },
          // ),
          Container(
            decoration: BoxDecoration(
              //color: const Color(0xff093f5c),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Container(
                  //height: 80,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    children: [
                      const Divider(color: Color(0xff893111), thickness: 2),
                      GestureDetector(
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_outline_outlined,
                                color: Color(0xff893111)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text('Upload New Media',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 40.0 / pixelRatio,
                                      color: const Color(0xff893111),
                                      fontFamily: 'Inter')),
                            )
                          ],
                        ),
                        onTap: SelectImage,
                      ),
                      const Divider(color: Color(0xff893111), thickness: 0.7),
                      GestureDetector(
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline,
                                color: Color(0xff893111)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                'Recently Deleted',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40.0 / pixelRatio,
                                  color: const Color(0xff893111),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            )
                          ],
                        ),
                        onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RecentlyDeletedPatient()));},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
