import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form/json_schema.dart';
import 'package:opinakanews/model/CustomTheme.dart';
import 'package:opinakanews/model/User.dart';
import 'package:opinakanews/util/Database.dart';
import 'package:opinakanews/util/MyTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page de connexion et première page affichée de l'application.
class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  dynamic reponse;

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.mainTitre')),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/logins');
            },
            icon: Icon(Icons.people),
          )
        ],
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.adb,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  Text(
                    tr('pages.connexion.titre'),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    tr('pages.connexion.enregistre'),
                    style:
                        TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person_add,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString("assets/login.json"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return JsonSchema(
                    padding: 10.0,
                    decorations: decorations,
                    form: snapshot.data,
                    onChanged: (dynamic reponse) {
                      this.reponse = reponse;
                    },
                    actionSave: (data) {
                      _showSnack(tr('snackOk'));
                      _check(data);
                    },
                    buttonSave: Container(
                      height: 40.0,
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Text(
                          tr('pages.connexion.continue'),
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: new CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Mise en forme du formulaire automatique Json.
  Map decorations = {
    'input1': InputDecoration(
      prefixIcon: Icon(Icons.account_box),
      border: OutlineInputBorder(),
    ),
    'password1': InputDecoration(
      prefixIcon: Icon(Icons.security),
      border: OutlineInputBorder(),
    ),
  };

  /// Vérification des données entrées par l'utilisateur.
  _check(dynamic data) async {
    User user = await DbHelper.db.getUser(data['fields'][0]['value']);
    user != null
        ? user.password == data['fields'][1]['value']
            ? _success(user.idUser, user.login)
            : _showMyDialog(tr('pages.connexion.dialPass'))
        : _showMyDialog(tr('pages.connexion.dialLog'));
  }

  /// Transition vers la page d'accueil.
  _success(int id, String login) async {
    _savePrefs(id, login);
    Navigator.pushNamedAndRemoveUntil(
        context, '/accueil', (Route<dynamic> route) => false);
  }

  /// Sauvegarde des détails utilisateur.
  _savePrefs(int id, String login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('boolLog', true);
      prefs.setInt('id', id);
      prefs.setString('user', login);
    });
  }

  /// Snackbar.
  void _showSnack(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  /// Boîte de dialogue.
  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('dialTitre')),
          content: SingleChildScrollView(
            child: Text(msg),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(tr('dialOk')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Récupération du thème personnalisé le cas échéant.
  getTheme() async {
    prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString('theme');
    if (theme != null) {
      CustomTheme myTheme = await DbHelper.db.getTheme(theme);
      if (myTheme != null) {
        MyTheme.changeTheme(context, myTheme);
      }
    }
  }
}
