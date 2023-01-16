import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/recently_deleted.dart';
import 'package:video_player/video_player.dart';

import 'create_notif.dart';
import 'home_carer.dart';

class ImageView2 extends StatefulWidget {
  String? category;
  var doc;
  ImageView2({this.category,this.doc});

  @override
  State<ImageView2> createState() => _ImageView2State();
}

class _ImageView2State extends State<ImageView2> {
  late VideoPlayerController _controller;
  bool isPlaying = false;
  bool started = false;
  late final player;
  void initState() {
    _controller = VideoPlayerController.network(widget.doc['Image Link'])..initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    widget.category == "video" ?  _controller.play() : null;
    player = AudioPlayer();
    super.initState();
  }
  void dispose(){
    widget.category == "video" ?  _controller.pause() : null;
    player.stop();
    super.dispose();
  }
  playFirst(player){
    player.play(UrlSource(widget.doc["Image Link"]));
    started = !started;
  }
  Future<Widget> checkType() async {
    if(widget.category == "image"){
      return Image.network(
        currentPhoto?.imageNetwork as String,
        fit: BoxFit.cover,
      );
    }else if(widget.category == "video"){
      return Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      );
    }else{
      return IconButton(
        onPressed:(){
          setState(() {
            if(!started){
              player.play(UrlSource(widget.doc["Image Link"]));
              isPlaying = !isPlaying;
              started = true;
              print("started");
            }else if(isPlaying){
              isPlaying = !isPlaying;
              player.pause();
              print("PAUSE");
            }else{
              isPlaying = !isPlaying;
              player.resume();
              print("PLAY");
            }

          });
        },
        icon: Icon(isPlaying ? Icons.pause_circle :  Icons.play_circle,size: 80,),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2.1: null;
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RecentlyDeleted())); },
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
                widget.doc['Title'],
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
          FutureBuilder<Widget>(
            future: checkType(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 100.0 / pixelRatio, 0, 0),
                    child: Container(
                        width: 600.0 / pixelRatio,
                        height: 600.0 / pixelRatio,
                        child: snapshot.data!
                    ),
                  ),
                );
              } else {
                /// you handle others state like error while it will a widget no matter what, you can skip it
                return CircularProgressIndicator();
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 100 / pixelRatio, 32.0, 0.0),
            child: Container(
              height: 500/pixelRatio,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xff893111),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    widget.doc['Description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 60.0 / pixelRatio,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 300 / pixelRatio, 0.0, 0.0),
                child: Row(
                  children: [
                    Container(
                      height: 150 / pixelRatio,
                      width: 300 / pixelRatio,
                      margin: EdgeInsets.all(2.5),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: ()async{
                            final imgRef = await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('trashBin').doc(widget.doc.id);
                            final getPic = await imgRef.get().then((value) => value.data());
                            final curPic = Picture.fromMap(getPic);
                            await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('gallery').add(curPic.toMap());
                            imgRef.delete();
                            String title = "Carer ${currentUser!.userName} restore a picture";
                            String body = "${widget.doc["Title"]} has been restored.";
                            Notify(title: title, body: body).Patient(currentPatient!.userID,null);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RecentlyDeleted()));
                          },
                          child: Text(
                            'restore',
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
                            primary: const Color(0xff893111),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 150 / pixelRatio,
                      width: 300 / pixelRatio,
                      margin: EdgeInsets.all(2.5),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Deleting File'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text('Would you like to permanently delete this file?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () async{
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () async{
                                        String title = "Carer ${currentUser!.userName} Permanently delete a picture";
                                        String body = "${widget.doc['Title']} has been Permanently deleted.";
                                        Notify(title: title, body: body).Patient(currentPatient!.userID,null);
                                        await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('trashBin').doc(widget.doc.id).delete();
                                        await FirebaseStorage.instance.refFromURL(widget.doc["Image Link"]).getMetadata().then((value) {
                                          var sizeInBytes= value.size;
                                          DatabaseService.updateStorageUsageDec(sizeInBytes, currentPatient);
                                        });
                                        FirebaseStorage.instance.refFromURL(widget.doc["Image Link"]).delete();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RecentlyDeleted()));
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'delete',
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
                            primary: const Color(0xff893111),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Picture {
  late String id;
  late String title;
  late String description;
  late String imageLink;
  late String type;


  Picture.fromMap(map) {
    id = map['ID'];
    title = map['Title'];
    imageLink = map['Image Link'];
    description = map['Description'];
    type = map['type'];
  }
  Map<String, dynamic> toMap() => {
    "ID": id,
    "Title": title,
    "Image Link" : imageLink,
    "Description" : description,
    "type" : type,

  };
}
