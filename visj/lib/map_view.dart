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
    var jSonTest = "[[7570.0,46.46328,5.04917],[583000.0,46.190458,5.20959],[583000.0,46.190458,5.20959],[135000.0,46.227254,4.863671],[52500.0,46.293795,5.093829],[8350.0,46.121478,5.345978],[156000.0,46.05386,5.347315],[100000.0,46.289407,5.196303],[173800.0,46.205123,5.230416],[4000.0,46.218103,5.361058],[251755.0,46.208685,5.226596],[1790.0,46.309893,5.356378],[1.0,46.251144,4.851017],[5000.0,46.361729,4.918867],[218000.0,46.199359,5.217646],[350000.0,46.2056,5.224004],[500.0,46.237186,5.226636],[168000.0,46.263427,4.887845],[70000.0,46.191336,5.211383],[13395.0,46.182805,5.320535],[70000.0,46.269712,5.215758],[140000.0,46.309211,5.249171],[7500.0,46.321936,5.429491],[90000.0,46.431831,4.975961],[2600.0,46.136045,5.32866],[3500.0,46.292692,5.115363],[129000.0,null,null],[98300.0,46.305375,4.873411],[169600.0,46.320048,5.284994],[5000.0,46.254201,5.277962],[58000.0,46.359876,5.250482],[3000.0,46.302787,5.110525],[140000.0,46.250967,5.199968],[75000.0,46.363293,4.918591],[131000.0,46.194963,5.209171],[202300.0,46.20355,5.225081],[535000.0,46.199119,5.220141],[28281.0,46.234896,5.230049],[107500.0,46.194534,5.11764],[175900.0,46.225729,4.881344],[10000.0,46.391013,5.038869],[60000.0,46.210108,5.226261],[700000.0,46.25057,5.126782],[2739.0,46.404065,4.93655],[77926.5,46.208685,5.226596],[100000.0,46.309605,4.876737],[318630.0,46.340065,4.994478],[33000.0,null,null],[2335.0,46.158586,5.390262],[55820.0,46.200365,5.228886],[55000.0,46.015205,5.294948],[2840.0,46.123958,5.470168],[264165.0,46.323846,6.047214],[110000.0,45.757257,5.686385],[5000.0,46.313558,6.068234],[4352.37,46.189148,5.577347],[326000.0,46.25007,6.028593],[29000.0,46.110476,5.550064],[229818.75,46.268495,5.663533],[375000.0,46.242027,6.025923],[14990.0,46.086336,5.40943],[70000.0,45.968346,5.808109],[238000.0,46.314871,6.067409],[1.0,45.826139,5.608875],[268000.0,46.242196,6.033592],[146000.0,46.265717,5.660464],[140120.0,46.195461,5.815257],[8570.0,46.228899,5.619989],[268100.0,46.263531,6.114663],[268100.0,46.242444,6.02745],[600000.0,46.241693,6.018499],[415000.0,46.370978,6.141928],[445000.0,46.246577,6.020862],[290000.0,46.025123,5.405143],[120000.0,46.114665,5.837593],[355000.0,46.269709,6.093583],[5500.0,45.906234,5.606625],[92000.0,45.731866,5.620837],[4500.0,45.916994,5.317675],[140000.0,45.807501,5.44698],[540000.0,45.925773,5.361363],[null,45.935998,5.342159],[1520532.0,46.306032,6.028103],[1520532.0,46.306032,6.028103],[1.0,46.115036,5.81971],[535000.0,46.32123,6.074515],[10500.0,46.212102,5.950684],[163000.0,46.247556,5.634613],[247200.0,46.338575,6.057433],[7373992.0,46.337852,6.0746],[61000.0,45.721231,5.711452],[235000.0,46.118569,5.887346],[3500.0,45.783805,5.55514],[200000.0,46.244019,5.665243],[3964038.0,46.353044,6.133965],[25000.0,46.242027,6.025923],[139000.0,45.90287,5.345981],[851067.0,46.041294,5.401457],[6527.3,45.84637,5.453233],[641200.0,46.283583,6.085283],[302621.0,46.353044,6.133965],[10000.0,46.194589,5.553359],[766987.1,46.263528,6.092928],[766987.1,46.263528,6.092928],[766987.1,46.263528,6.092928],[143000.0,45.898639,5.354882],[2357.5,45.804642,5.464756],[1696042.0,46.314871,6.067409],[3779.06,45.886155,5.334927],[345000.0,46.141456,5.90501],[345000.0,46.140966,5.904652],[110000.0,46.260418,5.649498],[16087064.0,46.276029,6.093479],[16087064.0,46.276029,6.093479],[368.7,46.037601,5.432515],[121316.0,45.895903,5.487066],[460000.0,46.192648,5.950831],[790000.0,46.280901,6.01272],[315000.0,46.100789,5.814807],[10288.5,46.032742,5.786945],[45000.0,45.930216,5.716164],[685960.0,46.345584,6.125683],[220200.0,46.13698,5.906107],[404000.0,46.276029,6.093479],[999000.0,46.363075,6.143815],[825000.0,46.314153,6.117453],[1090000.0,46.268995,6.094259],[2347569.0,45.951352,5.327193],[4200.0,46.174234,5.537148],[177000.0,46.107157,5.813422],[349900.0,46.289502,6.087684],[284550.0,45.939376,5.338151],[20000.0,46.092306,5.543581],[102600.0,45.695841,5.586777],[200000.0,45.980721,5.606577],[20000.0,45.883185,5.668797],[205000.0,46.253988,6.111686],[10000.0,46.190958,5.681131],[51000.0,46.241035,6.033738],[285000.0,46.340562,6.057714],[337500.0,46.075143,5.7802],[42500.0,45.821154,5.648749],[275000.0,46.263531,6.114663],[230000.0,45.739702,5.598121],[700000.0,46.238697,5.973779],[16000.0,46.094345,5.434008],[1800.0,45.86096,5.748236],[291564.0,45.920621,5.335531],[1000.0,46.35454,6.138491],[2500.0,45.972111,5.344384],[196000.0,46.295785,6.073025],[9500.0,46.239628,5.977513],[null,46.186376,5.546918],[163000.0,45.901621,5.346969],[105000.0,46.260768,6.114378],[180000.0,46.259126,5.657031],[19000.0,46.355898,6.141856],[4522.0,46.091783,5.461923],[78000.0,46.307238,5.946751],[336900.0,46.289502,6.087684],[55000.0,45.930207,5.686092],[8000.0,45.868126,5.695462],[175000.0,46.35696,6.145116],[58000.0,46.153289,5.605689],[5000.0,46.192143,5.472688],[130400.0,45.929444,5.516497],[447000.0,46.262345,6.113401],[160000.0,46.332757,6.063003],[135000.0,45.842697,5.249183],[71000.0,46.291561,6.073025],[700.0,46.096523,5.423495],[47500.0,46.264431,5.650373],[38000.0,45.826637,5.671046],[7100.0,45.901387,5.7182],[7100.0,45.895356,5.709861],[139000.0,46.247496,6.028496],[307750.0,46.134544,5.536133],[262050.0,45.811277,5.452401],[1500.0,46.019393,5.457581],[275000.0,46.31864,5.954419],[275000.0,46.31837,5.954239],[150000.0,45.870171,5.690339],[7500.0,45.871289,5.578604],[519300.0,46.234577,5.978852],[61200.0,46.17881,5.549481],[340000.0,46.297123,6.073391],[96650.0,45.696542,5.594489],[390150.0,46.345599,6.123328],[339000.0,46.241375,6.026486],[37000.0,45.973876,5.447652],[42627.0,45.725593,5.769998],[205000.0,45.957647,5.351817],[115000.0,46.303378,5.940979],[300000.0,45.936096,5.322661],[25000.0,null,null],[47000.0,null,null],[7998.0,46.018981,5.54053],[210000.0,null,null],[410000.0,46.363381,6.14538],[275000.0,46.244816,6.028108],[100000.0,null,null],[100000.0,null,null],[200000.0,45.779342,5.691673],[211451.0,45.962017,5.359934],[6000.0,45.866311,5.760498],[6000.0,45.853746,5.761639],[215000.0,null,null],[1600000.0,null,null],[800.0,46.195421,5.477802],[15000.0,46.097263,5.505281],[406700.0,46.344146,6.141916],[2700.0,46.002017,5.767854],[5000.0,45.855786,5.755217],[3000.0,46.126189,5.685655],[140000.0,46.21863,5.553998],[189000.0,45.781062,5.2124],[250000.0,46.25467,5.657136],[225790.0,46.000223,4.902139],[170500.0,45.871193,4.913306],[263500.0,45.912192,5.196141],[337500.0,45.846594,5.112858],[15010.0,46.049234,4.998366],[336150.0,45.946632,4.98137],[354000.0,45.956309,4.943279],[360000.0,45.938232,4.791122],[345100.0,45.877855,4.972576],[2358519.0,45.904213,5.190483],[null,45.849682,5.222222],[135000.0,45.981755,4.925312],[4204.5,45.85863,4.944477],[157000.0,45.851588,5.070863],[305000.0,46.022414,4.837681],[257250.0,45.95232,4.982459],[232000.0,45.826606,4.981527],[12315.25,46.074233,4.9053],[137000.0,46.002048,5.033023],[414036.0,null,null],[145000.0,null,null],[185000.0,46.232871,4.91329],[166940.0,46.119591,4.897371],[360000.0,45.987274,4.757895],[230000.0,null,null],[193000.0,45.939458,4.787702],[45000.0,null,null],[239200.0,46.188753,4.887794],[98500.0,45.993003,4.901296],[188000.0,45.851144,5.060267],[38000.0,49.688749,3.426441],[147050.0,49.691159,3.383988]]";
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
      if (vF != "null" && la != "null" && lo != "null"){
        Point p = new Point(lat: double.parse(la), long: double.parse(lo), valeurFonciere: double.parse(vF));
        pointList.add(p);
      }

    }
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