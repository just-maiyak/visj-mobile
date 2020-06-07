import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FormForEstimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormState();
}

/*
La classe contenant toutes les données qu'on veut envoyer au modèle
 */
class _FormData {
  String natureMutation;
  int codeTypeLocal;
  double lat = 0.0;
  double long = 0.0;
  int codePostal = 0;
  String codeCommune = '';
  String codeDepartement = '';
  int nombreLots = 0;
  String codeNatureCulture = '';
  double surfaceTerrain = 0.0;
}

class _FormState extends State<FormForEstimation> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  _FormData _data = _FormData();
  /*
  Le formulaire en lui-même
   */
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Form(
          key: this._formkey,
          child: ListView(
            children: <Widget>[
              DropdownButton(
                hint: Text('Selectionner le type de vente'),
                items: <String>[
                  'Vente',
                  "Vente en l'état futur d'achèvement",
                  'Adjudication',
                  'Echange',
                  'Vente terrain à bâtir',
                  'Expropriation'
                ]
                    .map((String v) => DropdownMenuItem(
                          value: v,
                          child: Text(v),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _data.natureMutation = v;
                  });
                },
                value: _data.natureMutation,
                isExpanded: true,
              ),
              DropdownButton(
                hint: Text('Selectionner le type de bien'),
                items: [
                  DropdownMenuItem(child: Text('Maison'), value: 1),
                  DropdownMenuItem(child: Text('Appartement'), value: 2),
                  DropdownMenuItem(child: Text('Dépendance'), value: 3),
                  DropdownMenuItem(child: Text('Local Commercial'), value: 4),
                ],
                onChanged: (v) {
                  setState(() {
                    _data.codeTypeLocal = v;
                  });
                },
                value: _data.codeTypeLocal,
                isExpanded: true,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "1 rue de Lyon 75012",
                    labelText: "Adresse sous forme N° + Voirie + Code Postal"),
                onSaved: (String value) {
                  getDataFromApi(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "1", labelText: 'Nombre de lots du bien'),
                validator: this._validateNombreLots,
                onSaved: (String value) {
                  this._data.nombreLots = int.parse(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "S",
                    labelText:
                        'Infos sur https://static.data.gouv.fr/resources/demande-de-valeurs-foncieres/20190419-091804/tables-de-reference-nature-de-culture.pdf'),
                validator: this._validateCodeNatureCulture,
                onSaved: (String value) {
                  this._data.codeNatureCulture = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "100.0", labelText: "Surface du bien en m²"),
                validator: this._validateSurface,
                onSaved: (String value) {
                  this._data.surfaceTerrain = double.parse(value);
                },
              ),
              Container(
                width: screenSize.width,
                child: RaisedButton(
                  child: Text(
                    'Estimer le bien',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: this.submit,
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(top: 20.0),
              )
            ],
          ),
        ),
      ),
    ));
  }

/**
 * Fonction utilitaire qui permet de parser le retour de l'appel a l'API du gouvernement.
 * Assigne directement la variable _data.
 */
  void getDataFromApi(adresse) async {
    var adressData = await apiGouv(adresse);
    setState(() {
      _data.codeDepartement = adressData.codeDepartement;
      _data.codeCommune = adressData.codeCommune;
      _data.codePostal = adressData.codePostal;
      _data.long = adressData.long;
      _data.lat = adressData.lat;
    });
  }

/*
Fonction de sauvegarde des données du formulaire dès que l'utilisateur presse le bouton et que tout est correct
Doit appeler l'autre page en y amenant les données de data
 */
  void submit() {
    //TODO Doit servir à mettre _data sur la'autre page pour appeler l'API
    if (this._formkey.currentState.validate()) {
      _formkey.currentState.save();

      print('\nPrinting Data :\n');
      print("Lon: ${_data.long}");
      print("Code Postal: ${_data.codePostal}");
    }
  }

/*
Toutes les fonctions de validations du formulaire
 */

  String _validateSurface(String value) {
    if (double.tryParse(value) == null || double.parse(value) < 0.0) {
      return "Rentrer une valeur valide";
    }
    return null;
  }

  String _validateCodeNatureCulture(String value) {
    var li = [
      "AB",
      "AG",
      "B",
      "BF",
      "BM",
      "BO",
      "BP",
      "BR",
      "BS",
      "BT",
      "CA",
      "CH",
      "E",
      "J",
      "L",
      "LB",
      "P",
      "PA",
      "PC",
      "PE",
      "PH",
      "PP",
      "S",
      "T",
      "TP",
      "VE",
      "VI"
    ].toList();
    if (!li.contains(value)) {
      return "Merci de saisir un code valide";
    }
    return null;
  }

  String _validateMutation(String value) {
    var mots = [
      'Vente',
      "Vente en l'état futur d'achèvement",
      'Adjudication',
      'Echange',
      'Vente terrain à bâtir',
      'Expropriation'
    ];
    if (!mots.contains(value)) {
      return "La valeur doit être Vente OU Vente en l'état futur d'achèvement OU Adjudication OU Echange OU Vente terrain à bâtir OU Expropriation";
    }
    return null;
  }

  String _validateNombreLots(String value) {
    if (int.tryParse(value) == null) {
      return "Merci de saisir un chiffre > 0";
    }
    int valueInt = int.parse(value);
    if (valueInt < 1) {
      return "Merci de saisir un chiffre > 0";
    }
    return null;
  }

  String _validateCodeTypeLocal(String value) {
    int valueInt = int.parse(value);
    if (valueInt > 4 || valueInt < 0) {
      return "1 pour Maison, 2 pour Appartement, 3 pour Dépendance et 4 pour Local Industriel/Commercial";
    }
    return null;
  }

  /*
  Exploitation de l'API du GOUV
  Param : adresse l'adresse dont on veut trouver des données géo, de la forme 1+rue+de+paris+78000
   */
  Future<AdressData> apiGouv(String adresse) async {
    String link = 'https://api-adresse.data.gouv.fr/search/?q=$adresse';
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var data;
    if (res.statusCode == 200) 
      data = json.decode(res.body)['features'][0];

    var props = Properties.fromJson(data["properties"]);
    var geo = Geometry.fromJson(data["geometry"]);

    double long = geo.coordinates[0];
    double lat = geo.coordinates[1];
    String codePostalStr = props.postcode;
    if (codePostalStr.startsWith("0")) {
      codePostalStr = codePostalStr.substring(1);
    }
    int codePostal = int.parse(codePostalStr);
    String codeCommuneStr = props.citycode;
    String codeDepartementStr = codeCommuneStr.substring(0,
        2); // Le code Dep dans nos données découle du code commune, sans 0 devant. Donc pour le dep 01 => 1, pour le dep 78 on garde 78
    codeCommuneStr = codeCommuneStr.substring(2,
        5); // Le code commune de nos données sont les 3 derniers caractères du code Communes donné par l'API, sans aucun 0 devant. 001 deviendra 1, 010 => 01
    if (codeDepartementStr.startsWith("0")) {
      //On enlève le 0 éventuel devant
      codeDepartementStr = codeDepartementStr.substring(1);
    }

    while (codeCommuneStr.startsWith("0")) {
      //On enlève les 0 éventuels devant
      codeCommuneStr = codeCommuneStr.substring(1);
    }

    var address = AdressData(
        lat: lat,
        long: long,
        codePostal: codePostal,
        codeCommune: codeCommuneStr,
        codeDepartement: codeDepartementStr);

    return address;
  }
}

class AdressData {
  double lat;
  double long;
  int codePostal;
  String codeCommune;
  String codeDepartement;
  AdressData(
      {this.lat,
      this.long,
      this.codePostal,
      this.codeCommune,
      this.codeDepartement});
  
  @override
  String toString() {
    return '$codePostal @ ($lat, $long)';
  }
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
      features = List<Features>();
      json['features'].forEach((v) {
        features.add(Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
    licence = json['licence'];
    query = json['query'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
