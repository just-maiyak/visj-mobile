import 'package:flutter/material.dart';

class Estimator extends StatefulWidget{
  @override
  EstimatorState createState() => new EstimatorState();
  
}

class EstimatorState extends State<Estimator> {
  @override
  Widget build(BuildContext context) => new Container(
    child: new Center(
        child: new Icon(Icons.euro_symbol, size: 100.0,),
      )
  );
}