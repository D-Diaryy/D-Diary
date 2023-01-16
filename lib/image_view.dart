import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/patient_album.dart';
import 'package:video_player/video_player.dart';

import 'create_notif.dart';
import 'edit_photo.dart';
import 'home_carer.dart';

class ImageView extends StatefulWidget {
  String? category;
  var doc;
  ImageView({this.category,this.doc});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatientAlbum())); },
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
                widget.doc["Title"],
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
                    widget.doc["Description"],
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
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 300 / pixelRatio, 32.0, 0.0),
            child: Row(
              children: [
                Container(
                  height: 150 / pixelRatio,
                  width: 350 / pixelRatio,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditPhoto(doc:widget.doc)));},
                      child: Text(
                        'edit',
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
                Spacer(),
                Container(
                  height: 150 / pixelRatio,
                  width: 350 / pixelRatio,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final imgRef = await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('gallery').doc(widget.doc.id);
                        final getPic = await imgRef.get().then((value) => value.data());
                        final curPic = Picture.fromMap(getPic);
                        await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('trashBin').doc(widget.doc.id).set(curPic.toMap());
                        imgRef.delete();
                        String title = "Carer ${currentUser!.userName} delete a picture";
                        String body = "${widget.doc['Title']} has been deleted.";
                        Notify(title: title, body: body).Patient(currentPatient!.userID,null);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatientAlbum()));
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
    "type" : type
  };
}
