import 'package:flutter/material.dart';
import 'estimation_form.dart';
class Estimator extends StatefulWidget {
  @override
  EstimatorState createState() => EstimatorState();
}
class EstimatorState extends State<Estimator> {
  var valeur_bien;
  String default_text = 'Estimez votre bien en cliquant en dessous';
  void evaluate() async {
    valeur_bien = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormForEstimation()));
    build(context);
  }
  @override
  Widget build(BuildContext context) => Container(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Text(valeur_bien != null
                ? 'Votre bien vaut $valeur_bien € !'
                : default_text),
          ),
          Container(
            width: 200,
            child: RaisedButton(
              child: Text(
                'Estimer le bien',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: this.evaluate,
              color: Colors.blue,
            ),
            margin: EdgeInsets.only(top: 20.0),
          ),
        ]),
      ));
}