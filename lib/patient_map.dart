
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'database.dart';
import 'home_carer.dart';
import 'track_patients.dart';

class PatientMap extends StatefulWidget {
  const PatientMap({Key? key}) : super(key: key);

  @override
  State<PatientMap> createState() => _PatientMapState();
}

class _PatientMapState extends State<PatientMap> {
  late LatLng destination;
  List<LatLng> polyLines = [];
  LatLng sourceLoc = LatLng(14, 121);
  MapController? mapcontroller;
  @override
  void initState(){
    destination = LatLng(currentPatient!.lat, currentPatient!.long);
    mapcontroller = MapController();
    super.initState();
  }
  setSource()async{
    Location location = await new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
    sourceLoc = LatLng(_locationData.latitude!, _locationData.longitude!);
    await getPolyPoints(["${sourceLoc.latitude},${sourceLoc.longitude}","${destination.latitude},${destination.longitude}"]);
    await mapcontroller!.move(sourceLoc,11);
    await createMarker();
  }
  Future getPolyPoints(List points)async{
    polyLines = [];
    final polypoints = await http.get(Uri.parse("https://graphhopper.com/api/1/route?point="+points[0]+"&point="+points[1]+"&profile=car&calc_points=true&key=80f50bd4-7b2d-42df-b60e-fac000c96fa8"));
    PolylinePoints polylinePoints = PolylinePoints();
    Map polypoints1 = jsonDecode(polypoints.body);
    List<PointLatLng> result = polylinePoints.decodePolyline(polypoints1["paths"][0]["points"]);
    result.forEach((coord) {
      polyLines.add(LatLng(coord.latitude, coord.longitude));
    });
  }
  List<Marker> Markers = [];
  createMarker(){
    Markers = [];
    setState(() {
      Markers.add(
        Marker(
          point: sourceLoc,
          width: 30,
          height: 30,
          builder: (context) => Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.5,style: BorderStyle.solid,color: Colors.green),
              borderRadius: BorderRadius.all(Radius.circular(99)),
            ),
            child:CircleAvatar(backgroundColor: Colors.red,backgroundImage: NetworkImage(currentUser!.profilePic)),
          ),
        ),
      );
      Markers.add(
        Marker(
          point: destination,
          width: 30,
          height: 30,
          builder: (context) => Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.5,style: BorderStyle.solid,color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(99)),
            ),
            child:CircleAvatar(backgroundColor: Colors.red,backgroundImage: NetworkImage(currentPatient!.profilePic)),
          ),
          //anchorPos: AnchorPos.exactly(Anchor(0, 5)),
        ),
      );
    });
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
              onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TrackPatients())); },
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
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 100 / pixelRatio, 0.0, 100 / pixelRatio),
            child: Text(
              currentPatient!.userName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 75.0 / pixelRatio,
                fontWeight: FontWeight.normal,
                color: const Color(0xffec8420),
                fontFamily: 'Inter',
              ),
            ),
          ),
          Container(
            height: 450,
            width: MediaQuery.of(context).size.width,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(14.5995,120.9842),
                zoom: 8,
              ),
              mapController: mapcontroller,
              nonRotatedChildren: [

              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                      strokeWidth:5,
                      points: polyLines,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  //start
                  markers: Markers,
                ),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 150 / pixelRatio, 32.0, 0.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  setSource();
                });
              },
              child: Container(
                height: 160/pixelRatio,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: const Color(0xffec8420),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Patient\'s Last Recorded Location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0 / pixelRatio,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
