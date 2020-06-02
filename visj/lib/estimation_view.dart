import 'package:flutter/material.dart';

class Estimator extends StatefulWidget{
  @override
  EstimatorState createState() => EstimatorState();
  
}

class EstimatorState extends State<Estimator> {
  @override
  Widget build(BuildContext context) => Container(
    child: Center(
        child: Icon(Icons.euro_symbol, size: 100.0,),
      )
  );
}