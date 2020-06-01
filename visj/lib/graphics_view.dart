import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  @override
  DashboardState createState() => new DashboardState();
  
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) => new Container(
    child: new Center(
        child: new Icon(Icons.view_quilt, size: 100.0,),
      )
  );
}