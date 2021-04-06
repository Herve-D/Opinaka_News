import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/model/CustomTheme.dart';
import 'package:opinakanews/ui/ThemeMaker.dart';
import 'package:opinakanews/util/Database.dart';
import 'package:opinakanews/util/MyTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page de sélection de thèmes.
class ThemeSet extends StatefulWidget {
  @override
  _ThemeSetState createState() => _ThemeSetState();
}

class _ThemeSetState extends State<ThemeSet> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.themeSet')),
      ),
      key: scaffoldKey,
      body: FutureBuilder<List<CustomTheme>>(
        future: DbHelper.db.getAllTheme(),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    CustomTheme item = snapshot.data[index];
                    return ExpansionTile(
                      leading: Icon(Icons.invert_colors),
                      title: Text(item.themeName),
                      children: <Widget>[
                        ListTile(
                          subtitle: FlatButton(
                              onPressed: () => _isBright()
                                  ? _saveTheme(item)
                                  : _showSnack(tr('pages.themeSet.noDark')),
                              child: Text(tr('pages.themeSet.select'))),
                          trailing: PopupMenuButton(
                            color: Theme.of(context).colorScheme.background,
                            icon: Icon(Icons.more_horiz),
                            elevation: 20.0,
                            shape: CircleBorder(
                                side: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: Center(
                                    child: Icon(
                                      Icons.colorize,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  child: Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ))
                            ],
                            onSelected: (dynamic value) {
                              if (value == 1) {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ThemeMaker(
                                                  true,
                                                  theme: item,
                                                )))
                                    .then((value) => setState(() {}));
                              } else if (value == 2) {
                                !(item.themeName == 'defaultLight' ||
                                        item.themeName == 'defaultDark')
                                    ? setState(() {
                                        DbHelper.db.suppTheme(item.themeName);
                                      })
                                    : _alertTxt(tr('pages.themeSet.noDel'));
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ThemeMaker(false)))
              .then((value) => setState(() {}));
        },
      ),
    );
  }

  /// Vérification de la luminosité du thème actuel.
  _isBright() {
    return Theme.of(context).brightness == Brightness.light ? true : false;
  }

  /// Changement du thème pour celui sélectionné.
  _saveTheme(CustomTheme theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('theme');
      prefs.setString('theme', theme.themeName);
    });
    MyTheme.changeTheme(context, theme);
  }

  /// Snackbar.
  _showSnack(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  /// Boîte de dialogue.
  _alertTxt(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(tr('dialTitre')),
          content: SingleChildScrollView(
            child: Text(message).tr(),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                tr('dialOk'),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
