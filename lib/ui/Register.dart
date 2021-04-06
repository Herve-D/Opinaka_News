import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form/json_schema.dart';
import 'package:opinakanews/model/User.dart';
import 'package:opinakanews/util/Database.dart';

/// Page d'inscription.
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic reponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.register')),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future:
              DefaultAssetBundle.of(context).loadString("assets/register.json"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  JsonSchema(
                    padding: 20.0,
                    decorations: decorations,
                    form: snapshot.data,
                    onChanged: (dynamic reponse) {
                      this.reponse = reponse;
                    },
                    actionSave: (data) async {
                      _showSnack(tr('snackOk'));
                      await DbHelper.db.addUser(new User(
                          login: data['fields'][0]['value'],
                          password: data['fields'][1]['value']));
                      Navigator.pop(context);
                    },
                    buttonSave: Container(
                      height: 40.0,
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Text(
                          tr('pages.register.continue'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(child: new CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  /// Mise en forme du formulaire automatique Json.
  Map decorations = {
    'login': InputDecoration(
      prefixIcon: Icon(Icons.account_box),
      border: OutlineInputBorder(),
    ),
    'password': InputDecoration(
      prefixIcon: Icon(Icons.security),
      border: OutlineInputBorder(),
    ),
  };

  /// Snackbar.
  void _showSnack(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }
}
