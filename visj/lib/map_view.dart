import 'package:flutter/material.dart';

class HeatMap extends StatefulWidget{
  @override
  MapState createState() => new MapState();
  
}

class MapState extends State<HeatMap> {
  @override
  Widget build(BuildContext context) => new Container(
    child: new Center(
        child: new Icon(Icons.map, size: 100.0,),
      )
  );
}