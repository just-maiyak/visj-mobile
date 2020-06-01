import 'package:flutter/material.dart';
import 'package:visj/list_view.dart' as list_view;

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
    controller = new TabController(length: 2, vsync: this);
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
        new list_view.Biens(),
        new Container(
          child: new Center(
            child: new Text('placeholder'),
          ),
        )
      ]),
      bottomNavigationBar: new Material(
        color: Colors.purple[300],
        child: new TabBar(
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.list)),
            new Tab(icon: new Icon(Icons.map)),
          ],
        ),
      ));
}