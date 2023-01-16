import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:patient_app/database.dart';

class FMap extends StatefulWidget {
  const FMap({Key? key}) : super(key: key);

  @override
  State<FMap> createState() => _FMapState();
}

class _FMapState extends State<FMap> {
  List<LatLng> polyLines = [];
  late LatLng sourceLoc;
  LatLng destination = LatLng(14.1320,121.2569);
  initState(){
    sourceLoc = LatLng(currentUser!.lat, currentUser!.long);
    super.initState();
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
  @override
  Widget build(BuildContext context) {
    //getPolyPoints(["${sourceLoc.latitude},${sourceLoc.longitude}","${destination.latitude},${destination.longitude}"]);
    return FlutterMap(
      options: MapOptions(
        center: sourceLoc,
        zoom: 13,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
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
          markers: [
            Marker(
              point: sourceLoc,
              width: 80,
              height: 80,
              builder: (context) => Icon(Icons.location_on,color: Colors.redAccent,),
            ),
          ],
        ),
        MarkerLayer(
          //destination
          markers: [
            Marker(
              point: destination,
              width: 80,
              height: 80,
              builder: (context) => Icon(Icons.location_on,color: Colors.redAccent,),
              //anchorPos: AnchorPos.exactly(Anchor(0, 5)),
            ),
          ],
        ),
      ],
    );
  }
}
