import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FormForEstimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _formState();
}
/*
La classe contenant toutes les données qu'on veut envoyer au modèle
 */
class _FormData {
  String natureMutation ='';
  int codeTypeLocal = 0;
  double lat = 0.0;
  double long = 0.0 ;
  int codePostal = 0;
  String codeCommune = '' ;
  String codeDepartement = '' ;
  int nombre_lots = 0;
  String codeNatureCulture = '';
  double surfaceTerrain = 0.0;
}

class _formState extends State<FormForEstimation> {
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  _FormData _data = new _FormData();
  /*
  Le formulaire en lui-même
   */
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key : this._formkey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: "Vente | Vente en l'état futur d'achèvement | Adjudication | Echange | Vente terrain à bâtir| Expropriation",
                  labelText: "Vente OU Vente en l'état futur d'achèvement OU Adjudication OU Echange OU Vente terrain à bâtir OU Expropriation"
                ),
                validator : this._validateMutation,
                onSaved: (String value){
                  this._data.natureMutation = value;
                },
              ),
              new TextFormField(
                decoration : new InputDecoration(
                  hintText: "1",
                  labelText: "1 pour Maison, 2 pour Appartement, 3 pour Dépendance et 4 pour Local Industriel/Commercial"
                ),
                validator: this._validateCodeTypeLocal,
                onSaved: (String value) {
                  this._data.codeTypeLocal = int.parse(value);
                }
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: "1 rue de Lyon 75012",
                  labelText: "Adresse sous forme N° + Voirie + Code Postal"
                ),
                onSaved: (String value){
                  String adresse = value.replaceAll(new RegExp(' '), '+');
                  AdressData a = apiGouv(adresse) as AdressData;
                  this._data.codeDepartement = a.codeDepartement;
                  this._data.codeCommune = a.codeCommune;
                  this._data.codePostal = a.codePostal;
                  this._data.long = a.long;
                  this._data.lat = a.lat;
                },
              ),
              new TextFormField(

                decoration: new InputDecoration(
                  hintText: "1",
                  labelText: 'Nombre de lots du bien'
                ),
                validator: this._validate_nombrelots,
                onSaved: (String value){
                  this._data.nombre_lots = int.parse(value);
                },
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: "S",
                  labelText: 'Infos sur https://static.data.gouv.fr/resources/demande-de-valeurs-foncieres/20190419-091804/tables-de-reference-nature-de-culture.pdf'
                ),
                validator: this._validateCodeNatureCulture,
                onSaved: (String value){
                  this._data.codeNatureCulture = value;
                },
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: "100.0",
                  labelText: "Surface du bien en m²"
                ),
                validator: this._validateSurface,
                onSaved: (String value){
                  this._data.surfaceTerrain = double.parse(value);
                },
              ),
              new Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Estimer le bien',
                    style: new TextStyle(
                        color:Colors.white
                    ),
                  ),
                  onPressed: this.submit,
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(
                    top:20.0
                ),
              )
            ],
          ),
        ),
      )
    );

  }
/*
Fonction de sauvegarde des données du formulaire dès que l'utilisateur presse le bouton et que tout est correct
Doit appeler l'autre page en y amenant les données de data
 */
  void submit(){ //TODO Doit servir à mettre _data sur la'autre page pour appeler l'API
    if(this._formkey.currentState.validate()){
      _formkey.currentState.save();

      print ('\nPrinting Data :\n');
      print("Lon: ${_data.long}");
      print("Code Postal: ${_data.codePostal}");
    }
  }

/*
Toutes les fonctions de validations du formulaire
 */

  String _validateSurface(String value){
    if(double.tryParse(value) == null || double.parse(value) < 0.0){
      return "Rentrer une valeur valide";
    }
    return null;
  }
  String _validateCodeNatureCulture(String value){
    var li = ["AB", "AG", "B", "BF","BM","BO","BP","BR","BS","BT","CA","CH","E","J","L","LB","P","PA","PC","PE","PH","PP","S","T","TP","VE","VI"].toList();
    if(! li.contains(value)){
      return "Merci de saisir un code valide";
    }
    return null;
  }
  String _validateMutation(String value){
    var mots = ['Vente', "Vente en l'état futur d'achèvement", 'Adjudication', 'Echange', 'Vente terrain à bâtir', 'Expropriation'];
    if(! mots.contains(value)){
      return "La valeur doit être Vente OU Vente en l'état futur d'achèvement OU Adjudication OU Echange OU Vente terrain à bâtir OU Expropriation";
    }
    return null;
  }

  String _validate_nombrelots(String value){
    if(int.tryParse(value) == null){
      return "Merci de saisir un chiffre > 0";
    }
    int valueInt = int.parse(value);
    if (valueInt < 1){
      return "Merci de saisir un chiffre > 0";
    }
    return null;
  }
  String _validateCodeTypeLocal(String value){
    int valueInt = int.parse(value);
    if (valueInt > 4 || valueInt < 0){
      return "1 pour Maison, 2 pour Appartement, 3 pour Dépendance et 4 pour Local Industriel/Commercial";
    }
    return null;
  }

  /*
  Exploitation de l'API du GOUV
  Param : adresse l'adresse dont on veut trouver des données géo, de la forme 1+rue+de+paris+78000
   */
  Future<AdressData> apiGouv(String adresse) async {
    String link = 'https://api-adresse.data.gouv.fr/search/?q='+adresse;
    List<Properties> listProperties;
    List<Geometry> listGeometry;
    var res = await http
    .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    print(res.body);
    if(res.statusCode == 200){
      var data = json.decode(res.body);
      var restProperties = data["properties"] as List;
      var restGeometry = data["geometry"] as List;
      print(restProperties);
      print(restGeometry);
      listProperties = restProperties.map<Properties>((json) => Properties.fromJson(json)).toList();
      listGeometry = restGeometry.map<Geometry>((json) => Geometry.fromJson(json)).toList();
    }

      double long = listGeometry[0].coordinates[0];
      double lat = listGeometry[0].coordinates[1];
      String codePostalStr = listProperties[0].postcode;
      if (codePostalStr.startsWith("0")){
        codePostalStr = codePostalStr.substring(1);
      }
      int codePostal = int.parse(codePostalStr);
      String codeCommuneStr = listProperties[0].citycode;
      String codeDepartementStr = codeCommuneStr.substring(0,2); // Le code Dep dans nos données découle du code commune, sans 0 devant. Donc pour le dep 01 => 1, pour le dep 78 on garde 78
      codeCommuneStr = codeCommuneStr.substring(2,5); // Le code commune de nos données sont les 3 derniers caractères du code Communes donné par l'API, sans aucun 0 devant. 001 deviendra 1, 010 => 01
      if (codeDepartementStr.startsWith("0")){ //On enlève le 0 éventuel devant
        codeDepartementStr = codeDepartementStr.substring(1);
      }

      while(codeCommuneStr.startsWith("0")){ //On enlève les 0 éventuels devant
        codeCommuneStr = codeCommuneStr.substring(1);
      }

      return AdressData(lat: lat, long: long, codePostal: codePostal, codeCommune: codeCommuneStr, codeDepartement: codeDepartementStr);

  }



}

class AdressData {
  double lat ;
  double long ;
  int codePostal ;
  String codeCommune ;
  String codeDepartement ;
  AdressData({this.lat, this.long, this.codePostal, this.codeCommune, this.codeDepartement});

}









//Pour parser le fichier JSON de l'api du gouv (https://javiercbk.github.io/json_to_dart/)
class Autogenerated {
  String type;
  String version;
  List<Features> features;
  String attribution;
  String licence;
  String query;
  int limit;

  Autogenerated(
      {this.type,
        this.version,
        this.features,
        this.attribution,
        this.licence,
        this.query,
        this.limit});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    version = json['version'];
    if (json['features'] != null) {
      features = new List<Features>();
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
    licence = json['licence'];
    query = json['query'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['version'] = this.version;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    data['attribution'] = this.attribution;
    data['licence'] = this.licence;
    data['query'] = this.query;
    data['limit'] = this.limit;
    return data;
  }
}

class Features {
  String type;
  Geometry geometry;
  Properties properties;

  Features({this.type, this.geometry, this.properties});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    return data;
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Properties {
  String label;
  double score;
  String housenumber;
  String id;
  String type;
  double x;
  double y;
  double importance;
  String name;
  String postcode;
  String citycode;
  String city;
  String district;
  String context;
  String street;

  Properties(
      {this.label,
        this.score,
        this.housenumber,
        this.id,
        this.type,
        this.x,
        this.y,
        this.importance,
        this.name,
        this.postcode,
        this.citycode,
        this.city,
        this.district,
        this.context,
        this.street});

  Properties.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    score = json['score'];
    housenumber = json['housenumber'];
    id = json['id'];
    type = json['type'];
    x = json['x'];
    y = json['y'];
    importance = json['importance'];
    name = json['name'];
    postcode = json['postcode'];
    citycode = json['citycode'];
    city = json['city'];
    district = json['district'];
    context = json['context'];
    street = json['street'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['score'] = this.score;
    data['housenumber'] = this.housenumber;
    data['id'] = this.id;
    data['type'] = this.type;
    data['x'] = this.x;
    data['y'] = this.y;
    data['importance'] = this.importance;
    data['name'] = this.name;
    data['postcode'] = this.postcode;
    data['citycode'] = this.citycode;
    data['city'] = this.city;
    data['district'] = this.district;
    data['context'] = this.context;
    data['street'] = this.street;
    return data;
  }
}