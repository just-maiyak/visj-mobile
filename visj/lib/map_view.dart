import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeatMap extends StatefulWidget{
  @override
  MapState createState() => MapState();
  
}

class MapState extends State<HeatMap> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kParis = CameraPosition(
    target: LatLng(48.864716, 2.336014),
    zoom: 11.5,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kParis,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ),
  );
}