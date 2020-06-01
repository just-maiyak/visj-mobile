import 'package:flutter/material.dart';
import 'package:visj/list_view.dart' as list_view;
import 'package:visj/map_view.dart' as map_view;
import 'package:visj/graphics_view.dart' as graphics_view;
import 'package:visj/estimation_view.dart' as estimation_view;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple[300],
        accentColor: Colors.indigoAccent,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        title: new Text('VISJ'),
      ),
      body: new TabBarView(controller: controller, children: <Widget>[
        new estimation_view.Estimator(),
        new map_view.HeatMap(),
        new graphics_view.Dashboard(),
        new list_view.Biens(),
      ]),
      bottomNavigationBar: new Material(
        color: Colors.purple[300],
        child: new TabBar(
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.euro_symbol)),
            new Tab(icon: new Icon(Icons.map)),
            new Tab(icon: new Icon(Icons.view_quilt)),
            new Tab(icon: new Icon(Icons.list)),
          ],
        ),
      ));
}