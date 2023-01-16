import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/patient_album.dart';
import 'package:patient_app/utils.dart';
import 'package:video_player/video_player.dart';

import 'create_notif.dart';
import 'home_carer.dart';

class EditPhoto extends StatefulWidget {
  final doc;
  const EditPhoto({this.doc});

  @override
  State<EditPhoto> createState() => _EditPhotoState();
}

class _EditPhotoState extends State<EditPhoto> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late VideoPlayerController _controller;
  bool isPlaying = false;
  bool started = false;
  late final player;
  void initState() {
    _controller = VideoPlayerController.network(widget.doc['Image Link'])..initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    widget.doc["type"] == ".mp4" ?  _controller.play() : null;
    player = AudioPlayer();
    super.initState();
  }
  void dispose(){
    widget.doc["type"] == ".mp4" ?  _controller.pause() : null;
    player.stop();
    super.dispose();
  }
  Future<Widget> checkType() async {
    if(widget.doc["type"] == ".mp4"){
      return Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      );
    }else if(widget.doc["type"] == ".mp3"){
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
    }else{
      return Image.network(
        currentPhoto?.imageNetwork as String,
        fit: BoxFit.cover,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    pixelRatio < 2 ? pixelRatio = 2: null;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
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
              TextFormField(
                textAlign: TextAlign.center,
                controller: titleController,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 60.0 / pixelRatio,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: widget.doc["Title"],
                  hintStyle: TextStyle(
                    fontSize: 60.0 / pixelRatio,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffec8420),
                    fontFamily: 'Inter',
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: const Color(0x00ffffff)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: const Color(0x00ffffff)),
                    borderRadius: BorderRadius.circular(20),
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
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: descriptionController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff),
                        ),
                        decoration: InputDecoration(
                          hintText:  widget.doc["Description"],
                          hintStyle: TextStyle(
                            fontSize: 60.0 / pixelRatio,
                            fontWeight: FontWeight.bold,
                            color: const Color(0x80ffffff),
                            fontFamily: 'Inter',
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: const Color(0xff893111)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: const Color(0xff893111)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32.0, 300 / pixelRatio, 32.0, 0.0),
                child: Container(
                  height: 150 / pixelRatio,
                  width: 350 / pixelRatio,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: updatePhoto,
                      child: Text(
                        'save',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future updatePhoto() async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(currentPatient!.userID).collection('gallery').doc( widget.doc.id).update({
        'Description' : descriptionController.text.trim() == "" ?  widget.doc["Description"] : descriptionController.text.trim(),
        'Title' : titleController.text.trim() == "" ?  widget.doc["Title"] : titleController.text.trim(),
      });
      String title = "Carer ${currentUser!.userName} edit a picture info";
      String body = "${ widget.doc["Title"]} has been edited.";
      Notify(title: title, body: body).Patient(currentPatient!.userID,null);
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    MyApp.navigatorKey.currentState!.popUntil((route) => route.isFirst);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatientAlbum()));
  }
}
