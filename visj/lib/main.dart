import 'package:flutter/material.dart';
import 'package:visj/list_view.dart' as list_view;
import 'package:visj/map_view.dart' as map_view;
import 'package:visj/graphics_view.dart' as graphics_view;
import 'package:visj/estimation_view.dart' as estimation_view;
import 'package:visj/estimation_form.dart' as  form_view;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple[300],
        accentColor: Colors.indigoAccent,
      ),
      home: HomePage(),
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
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('VISJ'),
      ),
      body: TabBarView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            form_view.FormForEstimation(),
            map_view.HeatMap(),
            graphics_view.Dashboard(),
            list_view.Biens(),
          ]),
      bottomNavigationBar: Material(
        color: Colors.purple[300],
        child: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(icon: Icon(Icons.euro_symbol)),
            Tab(icon: Icon(Icons.map)),
            Tab(icon: Icon(Icons.view_quilt)),
            Tab(icon: Icon(Icons.list)),
          ],
        ),
      ));
}
