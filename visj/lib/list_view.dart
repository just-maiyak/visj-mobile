import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Biens extends StatefulWidget{
  @override
  BiensState createState() => new BiensState();
  
}

class BiensState extends State<Biens> {
  @override
  Widget build(BuildContext context) => new Container(
    child: new Center(
        child: new Icon(Icons.format_list_bulleted, size: 100.0,),
      )
  );
}