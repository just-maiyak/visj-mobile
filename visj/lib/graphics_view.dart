import 'package:flutter/material.dart';
import 'package:visj/chartsLib.dart' as cL;
import 'package:charts_flutter/flutter.dart' as charts;

class Dashboard extends StatefulWidget{
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
             /*return Container(
                width: 200.0,
                height: 200.0,
                child: cL.SimpleLineChartPrix.withSampleData()
              ); */
             return ListView(
               children: <Widget>[
                 Container(
                   width: 200,
                   height: 200,
                   child: cL.SimpleLineChartPrix.withSampleData()
                 ),
                 Container(
                     width: 200,
                     height: 200,
                     child: cL.SimpleLineChartSurface.withSampleData()
                 )
               ],
             );
  }
}

class AvgPrice{
  final int dept;
  final double avgPrice;
  AvgPrice(this.dept, this.avgPrice);
}

class AvgSurface{
  final int dept;
  final double avgSurface;
  AvgSurface(this.dept, this.avgSurface);
}