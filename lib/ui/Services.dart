import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'file:///E:/Stage/Projets/OpinakaNews/opinaka_news/lib/model/EnumCategorie.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page d'abonnement aux services.
class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  SharedPreferences prefs;
  List<String> services = [];
  bool _check1 = false;
  bool _check2 = false;
  bool _check3 = false;
  bool _check4 = false;
  bool _check5 = false;
  bool _check6 = false;
  bool _check7 = false;
  bool _check8 = false;
  bool _check9 = false;
  bool _check10 = false;
  bool _check11 = false;

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.services')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: () => _save())
        ],
      ),
      body: ListView(
        children: <Widget>[
          CheckboxListTile(
            title: Text(tr('pages.services.economie')),
            value: _check1,
            onChanged: (val) {
              setState(() {
                _check1 = val;
                _check1
                    ? services.add(enumToString(Categorie.economie))
                    : services.remove(enumToString(Categorie.economie));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.emploi')),
            value: _check2,
            onChanged: (val) {
              setState(() {
                _check2 = val;
                _check2
                    ? services.add(enumToString(Categorie.emploi))
                    : services.remove(enumToString(Categorie.emploi));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.environnement')),
            value: _check3,
            onChanged: (val) {
              setState(() {
                _check3 = val;
                _check3
                    ? services.add(enumToString(Categorie.environnement))
                    : services.remove(enumToString(Categorie.environnement));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.immobilier')),
            value: _check4,
            onChanged: (val) {
              setState(() {
                _check4 = val;
                _check4
                    ? services.add(enumToString(Categorie.immobilier))
                    : services.remove(enumToString(Categorie.immobilier));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.loisirs')),
            value: _check5,
            onChanged: (val) {
              setState(() {
                _check5 = val;
                _check5
                    ? services.add(enumToString(Categorie.loisirs))
                    : services.remove(enumToString(Categorie.loisirs));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.mode')),
            value: _check6,
            onChanged: (val) {
              setState(() {
                _check6 = val;
                _check6
                    ? services.add(enumToString(Categorie.mode))
                    : services.remove(enumToString(Categorie.mode));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.multimedia')),
            value: _check7,
            onChanged: (val) {
              setState(() {
                _check7 = val;
                _check7
                    ? services.add(enumToString(Categorie.multimedia))
                    : services.remove(enumToString(Categorie.multimedia));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.politique')),
            value: _check8,
            onChanged: (val) {
              setState(() {
                _check8 = val;
                _check8
                    ? services.add(enumToString(Categorie.politique))
                    : services.remove(enumToString(Categorie.politique));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.sport')),
            value: _check9,
            onChanged: (val) {
              setState(() {
                _check9 = val;
                _check9
                    ? services.add(enumToString(Categorie.sport))
                    : services.remove(enumToString(Categorie.sport));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.vacances')),
            value: _check10,
            onChanged: (val) {
              setState(() {
                _check10 = val;
                _check10
                    ? services.add(enumToString(Categorie.vacances))
                    : services.remove(enumToString(Categorie.vacances));
              });
            },
          ),
          CheckboxListTile(
            title: Text(tr('pages.services.vehicule')),
            value: _check11,
            onChanged: (val) {
              setState(() {
                _check11 = val;
                _check11
                    ? services.add(enumToString(Categorie.vehicules))
                    : services.remove(enumToString(Categorie.vehicules));
              });
            },
          ),
        ],
      ),
    );
  }

  /// Récupération des abonnements.
  _load() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('services')) {
        services = prefs.getStringList('services');
        _check1 = services.contains(enumToString(Categorie.economie));
        _check2 = services.contains(enumToString(Categorie.emploi));
        _check3 = services.contains(enumToString(Categorie.environnement));
        _check4 = services.contains(enumToString(Categorie.immobilier));
        _check5 = services.contains(enumToString(Categorie.loisirs));
        _check6 = services.contains(enumToString(Categorie.mode));
        _check7 = services.contains(enumToString(Categorie.multimedia));
        _check8 = services.contains(enumToString(Categorie.politique));
        _check9 = services.contains(enumToString(Categorie.sport));
        _check10 = services.contains(enumToString(Categorie.vacances));
        _check11 = services.contains(enumToString(Categorie.vehicules));
      }
    });
  }

  /// Sauvegarde des abonnements.
  _save() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('services', services);
    });
    Navigator.pop(context);
  }
}
