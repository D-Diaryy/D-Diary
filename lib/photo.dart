import 'package:cloud_firestore/cloud_firestore.dart';

class Photo{

  final String imageNetwork;
  final String imageTitle;
  final String imageDescription;
  final String imageID;

  Photo({
    required this.imageNetwork,
    required this.imageTitle,
    required this.imageDescription,
    required this.imageID,
  });

  factory Photo.fromDocument(DocumentSnapshot doc) {
    return Photo(
      imageNetwork: doc['Image Link'],
      imageTitle: doc['Title'],
      imageDescription: doc['Description'],
      imageID: doc['ID'],
    );
  }
}

class Gallery{
  final List imageList;
  Gallery({required this.imageList});

  factory Gallery.getImages(QuerySnapshot gallery){
    List imgList = [];
    gallery.docs.forEach((e) {
      if (e['type'] == ".jpg" || e['type'] == ".png" || e['type'] == ".jpeg") {
        imgList.add(e['Image Link']);
      }
      /*
      e['type'] != ".mp3" ? imgList.add(e['Image Link']) : e['type'] != ".mp4" ? imgList.add(e['Image Link']) : null;
      print(e["type"]);

       */
    });
    return Gallery(
        imageList: imgList,
    );
  }

}