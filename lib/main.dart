import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/ui/Accueil.dart';
import 'package:opinakanews/ui/Calendrier.dart';
import 'package:opinakanews/ui/Carte.dart';
import 'package:opinakanews/ui/Connexion.dart';
import 'package:opinakanews/ui/Liste.dart';
import 'package:opinakanews/ui/Users.dart';
import 'package:opinakanews/ui/NotificationDetails.dart';
import 'package:opinakanews/ui/NotificationListe.dart';
import 'package:opinakanews/ui/Register.dart';
import 'package:opinakanews/ui/Requests.dart';
import 'package:opinakanews/ui/Services.dart';
import 'package:opinakanews/ui/Settings.dart';
import 'package:opinakanews/ui/ThemeSet.dart';
import 'package:opinakanews/ui/View.dart';
import 'package:opinakanews/util/MyTheme.dart';

/// Point d'entrée de l'application et chargement des langues.
void main() => runApp(EasyLocalization(
      supportedLocales: [
        Locale('en', 'GB'),
        Locale('es', 'ES'),
        Locale('fr', 'FR')
      ],
      path: 'assets/lang',
//      assetLoader: JsonAssetLoader(),
      fallbackLocale: Locale('fr', 'FR'),
      child: MyApp(),
    ));

/// Chargement des thèmes et routes.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => brightness == Brightness.light
            ? MyTheme.defaultTheme
            : MyTheme.darkTheme,
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Opinaka News',
            theme: theme,
            initialRoute: '/connexion',
            routes: {
              '/accueil': (context) => Accueil(),
              '/calendrier': (context) => Calendrier(),
              '/carte': (context) => Carte(),
              '/connexion': (context) => Connexion(),
              '/listeBoucle': (context) => ListeBoucle(),
              '/logins': (context) => Users(),
              '/notifDetails': (context) => NotificationDetails(
                  notification: ModalRoute.of(context).settings.arguments),
              '/notifListe': (context) => NotificationListe(
                  updateUnread: ModalRoute.of(context).settings.arguments),
              '/register': (context) => Register(),
              '/requests': (context) => Requests(),
              '/services': (context) => Services(),
              '/settings': (context) => Settings(),
              '/themes': (context) => ThemeSet(),
              '/view': (context) =>
                  View(detail: ModalRoute.of(context).settings.arguments),
            },
          );
        },
      ),
    );
  }
}
