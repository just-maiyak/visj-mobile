import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Biens extends StatefulWidget{
  @override
  BiensState createState() => BiensState();
  
}

class BiensState extends State<Biens> {
  @override
  Widget build(BuildContext context) => Container(
    child: Center(
        child: Icon(Icons.format_list_bulleted, size: 100.0,),
      )
  );
}