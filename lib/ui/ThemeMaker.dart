import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:opinakanews/model/CustomTheme.dart';
import 'package:opinakanews/util/Database.dart';

/// Page de création/modification de thèmes.
class ThemeMaker extends StatefulWidget {
  final bool edit;
  final CustomTheme theme;

  ThemeMaker(this.edit, {this.theme}) : assert(edit == true || theme == null);

  @override
  _ThemeMakerState createState() => _ThemeMakerState();
}

class _ThemeMakerState extends State<ThemeMaker> {
  final myController = TextEditingController();
  Color _color1, _color2, _color3, _color4, _color5, _color6;
  var btn = tr('pages.themeMaker.change');

  @override
  void initState() {
    _checkColors();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit
            ? tr('pageNames.themeMakerEdit')
            : tr('pageNames.themeMakerNew')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: _checkOk)
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(widget.edit ? null : Icons.edit),
            title: TextField(
              enabled: widget.edit ? false : true,
              maxLength: 20,
              controller: myController,
              decoration: InputDecoration(
                  labelText: tr('pages.themeMaker.name'),
                  labelStyle: TextStyle(fontStyle: FontStyle.italic)),
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(tr('pages.themeMaker.titre1')),
            subtitle: Text(
              tr('pages.themeMaker.sub1'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: RaisedButton(
              elevation: 10.0,
              shape: Border.all(),
              child: Text(
                btn,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              textColor: useWhiteForeground(_color1)
                  ? Color(0xffffffff)
                  : Color(0xff000000),
              color: _color1,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(5.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _color1,
                          onColorChanged: _changeColor1,
                          enableLabel: false,
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(tr('pages.themeMaker.titre2')),
            subtitle: Text(
              tr('pages.themeMaker.sub2'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: RaisedButton(
              elevation: 10.0,
              shape: Border.all(),
              child: Text(
                btn,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              textColor: useWhiteForeground(_color2)
                  ? Color(0xffffffff)
                  : Color(0xff000000),
              color: _color2,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(5.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _color2,
                          onColorChanged: _changeColor2,
                          enableLabel: false,
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(tr('pages.themeMaker.titre3')),
            subtitle: Text(
              tr('pages.themeMaker.sub3'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: RaisedButton(
              elevation: 10.0,
              shape: Border.all(),
              child: Text(
                btn,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              textColor: useWhiteForeground(_color3)
                  ? Color(0xffffffff)
                  : Color(0xff000000),
              color: _color3,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(5.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _color3,
                          onColorChanged: _changeColor3,
                          enableLabel: false,
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(tr('pages.themeMaker.titre4')),
            subtitle: Text(
              tr('pages.themeMaker.sub4'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: RaisedButton(
              elevation: 10.0,
              shape: Border.all(),
              child: Text(
                btn,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              textColor: useWhiteForeground(_color4)
                  ? Color(0xffffffff)
                  : Color(0xff000000),
              color: _color4,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(5.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _color4,
                          onColorChanged: _changeColor4,
                          enableLabel: false,
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(tr('pages.themeMaker.titre5')),
            subtitle: Text(
              tr('pages.themeMaker.sub5'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: RaisedButton(
              elevation: 10.0,
              shape: Border.all(),
              child: Text(
                btn,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              textColor: useWhiteForeground(_color5)
                  ? Color(0xffffffff)
                  : Color(0xff000000),
              color: _color5,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(5.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _color5,
                          onColorChanged: _changeColor5,
                          enableLabel: false,
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(tr('pages.themeMaker.titre6')),
            subtitle: Text(
              tr('pages.themeMaker.sub6'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: RaisedButton(
              elevation: 10.0,
              shape: Border.all(),
              child: Text(
                btn,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              textColor: useWhiteForeground(_color6)
                  ? Color(0xffffffff)
                  : Color(0xff000000),
              color: _color6,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(5.0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: _color6,
                          onColorChanged: _changeColor6,
                          enableLabel: false,
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// Modification non autorisée des thèmes par défaut.
  _checkOk() {
    myController.text == 'defaultLight' || myController.text == 'defaultDark'
        ? _alertTxt(tr('pages.themeMaker.noEdit'))
        : _save();
  }

  /// Sauvegarde d'un thème.
  _save() async {
    if (myController.text.isEmpty) {
      _alertTxt(tr('pages.themeMaker.noName'));
    } else {
      if (widget.edit) {
        DbHelper.db.updateTheme(new CustomTheme(
            themeName: myController.text,
            primaryColor: _color1.value,
            primaryColorDark: _color2.value,
            secondaryColor: _color3.value,
            secondaryColorDark: _color4.value,
            background: _color5.value,
            textColor: _color6.value));
        Navigator.pop(context);
      } else {
        await DbHelper.db.addTheme(new CustomTheme(
            themeName: myController.text,
            primaryColor: _color1.value,
            primaryColorDark: _color2.value,
            secondaryColor: _color3.value,
            secondaryColorDark: _color4.value,
            background: _color5.value,
            textColor: _color6.value));
        Navigator.pop(context);
      }
    }
  }

  /// Affichage des couleurs de choix/choisies.
  _checkColors() {
    if (widget.edit) {
      myController.text = widget.theme.themeName;
      _color1 = new Color(widget.theme.primaryColor);
      _color2 = new Color(widget.theme.primaryColorDark);
      _color3 = new Color(widget.theme.secondaryColor);
      _color4 = new Color(widget.theme.secondaryColorDark);
      _color5 = new Color(widget.theme.background);
      _color6 = new Color(widget.theme.textColor);
    } else {
      _color1 = Colors.white;
      _color2 = Colors.white;
      _color3 = Colors.white;
      _color4 = Colors.white;
      _color5 = Colors.white;
      _color6 = Colors.white;
    }
  }

  void _changeColor1(Color color) => setState(() => _color1 = color);

  void _changeColor2(Color color) => setState(() => _color2 = color);

  void _changeColor3(Color color) => setState(() => _color3 = color);

  void _changeColor4(Color color) => setState(() => _color4 = color);

  void _changeColor5(Color color) => setState(() => _color5 = color);

  void _changeColor6(Color color) => setState(() => _color6 = color);

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
