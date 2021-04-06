import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/util/ListeWidget.dart';
import 'package:opinakanews/util/MyTheme.dart';

/// Page d'accès aux configurations de l'application.
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _light = false;
  List _fontList = ['Roboto', 'Bangers', 'Lobster', 'Pacifico', 'Pangolin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.settings')),
      ),
      body: ListView(
        children: <Widget>[
          /// Accès aux thèmes.
          myListWidget(
            context: context,
            child: ListTile(
              leading: Icon(
                Icons.color_lens,
                color: Theme.of(context).accentColor,
              ),
              title: Text(tr('pages.settings.themes')),
              onTap: () {
                Navigator.pushNamed(context, '/themes');
              },
            ),
          ),

          /// Choix entre mode clair et mode sombre.
          myListWidget(
            context: context,
            child: SwitchListTile(
              secondary: Icon(
                _isLight() ? Icons.highlight : Icons.lightbulb_outline,
                color: Theme.of(context).accentColor,
              ),
              title: Text(tr('pages.settings.dark')),
              value: !_isLight(),
              onChanged: (bool value) {
                setState(() {
                  _light = value;
                  _turnOnOffLight();
                });
              },
            ),
          ),

          /// Choix de police de caractères.
          myListWidget(
            context: context,
            child: ListTile(
              leading: Icon(
                Icons.font_download,
                color: Theme.of(context).accentColor,
              ),
              title: Text(tr('pages.settings.police')),
              subtitle: DropdownButton(
                value: Theme.of(context).textTheme.bodyText2.fontFamily,
                elevation: 16,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onBackground),
                icon: Icon(
                  Icons.arrow_left,
                  color: Theme.of(context).accentColor,
                ),
                underline: Container(
                  height: 0.5,
                  color: Theme.of(context).accentColor,
                ),
                isExpanded: true,
                dropdownColor: Theme.of(context).primaryColor,
                items: _fontList
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontFamily: item),
                        )))
                    .toList(),
                onChanged: (value) => _setFont(value),
              ),
            ),
          ),

          /// Choix de langue.
          myListWidget(
            context: context,
            child: ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).accentColor,
              ),
              title: Text(tr('pages.settings.langues')),
              subtitle: DropdownButton(
                value: context.locale,
                elevation: 16,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onBackground),
                icon: Icon(
                  Icons.arrow_left,
                  color: Theme.of(context).accentColor,
                ),
                underline: Container(
                  height: 0.5,
                  color: Theme.of(context).accentColor,
                ),
                isExpanded: true,
                dropdownColor: Theme.of(context).primaryColor,
                items: [
                  DropdownMenuItem(
                    value: context.supportedLocales[0],
                    child: Text('English - United Kingdom'),
                  ),
                  DropdownMenuItem(
                    value: context.supportedLocales[1],
                    child: Text('Español - España'),
                  ),
                  DropdownMenuItem(
                    value: context.supportedLocales[2],
                    child: Text('Français - France'),
                  )
                ],
                onChanged: (value) => {context.locale = value},
              ),
            ),
          ),

          /// Accès aux abonnements.
          myListWidget(
            context: context,
            child: ListTile(
              leading: Icon(
                Icons.subscriptions,
                color: Theme.of(context).accentColor,
              ),
              title: Text(tr('pages.settings.services')),
              onTap: () {
                Navigator.pushNamed(context, '/services');
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Ajustement couleur du texte selon la luminosité du thème actuel.
  _setFont(String value) {
    _isLight()
        ? MyTheme.fontBlack(
            context: context,
            scheme: Theme.of(context).colorScheme,
            font: value)
        : MyTheme.fontWhite(
            context: context,
            scheme: Theme.of(context).colorScheme,
            font: value);
  }

  /// Vérification de la luminosité du thème actuel.
  bool _isLight() {
    Theme.of(context).brightness == Brightness.light
        ? _light = true
        : _light = false;
    return _light;
  }

  /// Bascul entre mode clair et mode sombre.
  void _turnOnOffLight() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }
}
