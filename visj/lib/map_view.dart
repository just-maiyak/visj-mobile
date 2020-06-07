import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    getDataFromServ();
    //Can create multiple points here
    //points.add(_createWeightedLatLng(location.latitude,location.longitude, 1));
    //points.add(_createWeightedLatLng(location.latitude-1,location.longitude, 1));
    for(int i = 0; i < listePoints.length; i++){
      double vF = listePoints[i].valeurFonciere;
      double la = listePoints[i].lat;
      double lo = listePoints[i].long;
      points.add(_createWeightedLatLng(la, lo, 1));
    }
    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  Future<List> dataFromServ() async {
   /**String link = 'http://0.0.0.0:5000/data_heatmap';
    var res = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var data;
    if (res.statusCode == 200)
      List data = json.decode(res.body);
       **/
    var jSonTest = "[[7570.0,46.46328,5.04917],[583000.0,46.190458,5.20959],[583000.0,46.190458,5.20959],[135000.0,46.227254,4.863671],[52500.0,46.293795,5.093829],[8350.0,46.121478,5.345978],[156000.0,46.05386,5.347315],[100000.0,46.289407,5.196303],[173800.0,46.205123,5.230416],[4000.0,46.218103,5.361058]]";
    List data = json.decode(jSonTest);
    List pointList = new List();
    print("Taille data");
    print(data.length);
    print(data[0][0]);
    print(data[0][1]);
    print(data[0][2]);
    for (int i = 0; i < data.length; i++){
      var vF = data[i][0];
      var la = data[i][1];
      var lo = data[i][2];
      if (/**vF != null && la != null && lo != null **/ 1==1){
        Point p = new Point(lat:la, long: lo, valeurFonciere:vF);
        pointList.add(p);
      }

    }
    print(pointList.first.lat);
    return pointList;
  }

  List<Point> listePoints = new List<Point>();
  void getDataFromServ() async {
    var list = await dataFromServ();
    setState(() {
      for (int i = 0; i < list.length; i++){
        listePoints.add(list[i]);
      }
    });
  }

  }

class Point{
  double lat;
  double long;
  double valeurFonciere;
  Point({this.lat, this.long,this.valeurFonciere});
}