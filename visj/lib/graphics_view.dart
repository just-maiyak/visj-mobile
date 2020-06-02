import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  @override
  DashboardState createState() => DashboardState();
  
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) => Container(
    child: Center(
        child: Icon(Icons.view_quilt, size: 100.0,),
      )
  );
}