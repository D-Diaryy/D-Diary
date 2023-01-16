import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path/path.dart' as Path;
import 'package:path/path.dart' as p;
import 'package:patient_app/database.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/recently_deleted.dart';
import 'package:patient_app/utils.dart';

import 'albums.dart';
import 'constant.dart';
import 'create_notif.dart';
import 'home_carer.dart';
import 'image_view.dart';

class PatientAlbum extends StatefulWidget {
  const PatientAlbum({Key? key}) : super(key: key);

  @override
  State<PatientAlbum> createState() => _PatientAlbumState();
}

class _PatientAlbumState extends State<PatientAlbum> {
  late File _imageFile;
  final picker = ImagePicker();
  final DatabaseService storage = DatabaseService(uid: '1');
  double progress = 0.0;
  //Niiko
  List<XFile>? _imageFilelist = [];
  doUpload(file)async{
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatientAlbum()));
        }
      });
    });
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      print(file.lengthSync() + currentPatient!.totalSize);
      DatabaseService.updateStorageUsage(file.lengthSync(),currentPatient);
    });
    String tempLink = await taskSnapshot.ref.getDownloadURL() as String;
    await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('gallery').add({
      'Image Link': tempLink,
      'Title': 'Title of Media',
      'Description': 'Description',
      'ID' : '',
      'type' : p.extension(file.path),
    });
    String? title = 'Carer ${currentUser!.userName} added a file for you';
    String? body = 'A file has been added';
    Notify(title: title,body: body).Patient(currentPatient!.userID,null);
    Notify(title: title,body: body).OtherCarers(null,currentPatient!.code.toString());
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
        if(currentPatient!.totalSize + e.lengthSync() > 5368709120){
          String title = "Your on file size limit";
          String body = "Users can't upload unless permanently delete files.";
          Utils.showSnackBar("Exceeded limit cannot add more files.");
          Notify(title: title,body: body).Patient(currentPatient!.userID,null);
          Notify(title: title,body: body).OtherCarers(null,currentPatient!.code.toString());
        }else{
          if(p.extension(e.path) == ".mp4"){
            if(sizeInMb < 200){
              await doUpload(e);
            }else{
              String title = "Carer ${currentUser!.fullName} try to upload a large video.";
              String body = "Size of ${Path.basename(e.path)} video exceeded 200mb quota.";
              Utils.showSnackBar(title);
              Notify(title: title,body: body).Patient(currentPatient!.userID,null);
              Notify(title: title,body: body).OtherCarers(null,currentPatient!.code.toString());
            }
          }else{
            if(sizeInMb < 25){
              await doUpload(e);
            }else{
              String title = "Carer ${currentUser!.fullName} try to upload a large file.";
              String body = "Size of ${Path.basename(e.path)} video exceeded 25mb quota.";
              Utils.showSnackBar(title);
              Notify(title: title,body: body).Patient(currentPatient!.userID,null);
              Notify(title: title,body: body).OtherCarers(null,currentPatient!.code.toString());
            }
          }
        }


      });
    }
  }
  //Niiko
  Future pickImage() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if(selectedImages!.isNotEmpty){
      _imageFilelist!.addAll(selectedImages);
    }
    await uploadImageToFirebase(MyApp.navigatorKey.currentContext!);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    for(int i = 0;i<_imageFilelist!.length;i++) {
      String fileName = Path.basename(_imageFilelist![i].path);
      firebase_storage.Reference firebaseStorageref = firebase_storage
          .FirebaseStorage.instance.ref().child(
          currentUser!.userID + '/photos/$fileName');
      firebase_storage.UploadTask uploadTask = firebaseStorageref.putFile(
          File(_imageFilelist![i].path));
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask
          .whenComplete(() {});
      String tempLink = await taskSnapshot.ref.getDownloadURL() as String;
      await FirebaseFirestore.instance.collection('users').doc(
          currentUser!.userID).collection('gallery').add({
        'Image Link': tempLink,
        'Title': 'Title of Media',
        'Description': 'Description',
        'ID': '',
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

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageView(category: "video",doc:retDoc)));
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageView(category: "audio",doc:retDoc)));
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
                await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('gallery').doc(retDoc.id).update({
                  'ID' : retDoc.id,
                });
                await DatabaseService(uid: '').getPhotoDataCarer(retDoc.id);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ImageView(category: "image",doc:retDoc)));
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Albums())); },
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
                    onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeCarer())); },
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
            stream: FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('gallery').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(
                  child: _buildList(snapshot.data!)
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              //color: const Color(0xff093f5c),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 32),
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
                        onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RecentlyDeleted()));},
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
