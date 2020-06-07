import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
class HeatMap extends StatefulWidget{
  @override
  MapState createState() => MapState();
  
}

class MapState extends State<HeatMap> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Heatmap> _heatmaps = {};
  static final CameraPosition _kParis = CameraPosition(
    target: LatLng(48.864716, 2.336014),
    zoom: 11.5,
  );
  LatLng _heatmapLocation = LatLng(48.864716, 2.336014);
  static final CameraPosition _kHeatMap = CameraPosition(
    target: LatLng(48.864716, 2.336014),
    zoom: 11.5,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kParis,
      heatmaps: _heatmaps,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
        onPressed: _addHeatmap,
        label: Text('Add Heatmap'),
        icon: Icon(Icons.add_box),
  ),
  );
  void _addHeatmap(){
    setState(() {
      _heatmaps.add(
          Heatmap(
              heatmapId: HeatmapId(_heatmapLocation.toString()),
              points: _createPoints(_heatmapLocation),
              radius: 20,
              visible: true,
              gradient:  HeatmapGradient(
                  colors: <Color>[Colors.green, Colors.red], startPoints: <double>[0.2, 0.8]
              )
          )
      );
    });
  }
  //heatmap generation helper functions
  List<WeightedLatLng> _createPoints(LatLng location) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here
    points.add(_createWeightedLatLng(location.latitude,location.longitude, 1));
    points.add(_createWeightedLatLng(location.latitude-1,location.longitude, 1));
    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }


}