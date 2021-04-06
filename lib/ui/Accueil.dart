import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/util/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page principale de l'application, contenant un tableau de bord ainsi qu'un drawer avec les menus de navigation.
class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences _prefs;
  String _user;
  bool _log = false;
  Map<String, int> _count = {
    'pages.accueil.docRead': 0,
    'pages.accueil.docUnread': 0,
    'pages.accueil.docTotal': 0,
    'pages.accueil.notifUnread': 0
  };

  @override
  void initState() {
    _getPrefs();
    _getNotifUnread();
    _getDocCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.mainTitre')),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      _helloUser(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.all(50.0),
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(tr('pages.accueil.connexion')),
                    onTap: () {
                      Navigator.pushNamed(context, '/connexion');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.apps),
                    title: Text(tr('pageNames.liste')),
                    onTap: () {
                      Navigator.pushNamed(context, '/listeBoucle');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(tr('pageNames.calendrier')),
                    onTap: () {
                      Navigator.pushNamed(context, '/calendrier');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.archive),
                    title: Text(tr('pageNames.request')),
                    onTap: () {
                      Navigator.pushNamed(context, '/requests');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text(tr('pageNames.carte')),
                    onTap: () {
                      Navigator.pushNamed(context, '/carte');
                    },
                  ),
                  ListTile(
                    leading: _count['pages.accueil.notifUnread'] > 0
                        ? _myNotifIcon()
                        : Icon(Icons.notifications),
                    title: Text(tr('pageNames.notifListe')),
                    onTap: () {
                      Navigator.pushNamed(context, '/notifListe',
                          arguments: refreshNotif);
                    },
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(tr('pageNames.settings')),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  )
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Divider(
                      color: Theme.of(context).accentColor,
                      height: 10,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text(tr('pages.accueil.deconnexion')),
                      onTap: () {
                        _logout();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(15.0),
              child: Image.asset(
                'assets/soleil72.png',
              ),
            ),
            _myContainer(
              child: Text(
                tr('pages.accueil.logo'),
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.primaryVariant
                ],
                radius: 0.9,
              ),
            ),
            _myContainer(
              child: _overview(),
            ),
          ],
        ),
      ),
    );
  }

  /// Construction d'un container personnalisé.
  Widget _myContainer({Widget child, Gradient gradient}) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(35.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).accentColor,
            offset: Offset(10.0, 5.0),
            blurRadius: 20.0,
          ),
        ],
        gradient: gradient,
      ),
      child: child,
    );
  }

  /// Construction de l'affichage de différents statistiques provenant de la BDD.
  Widget _overview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Align(
              child: Text(
                tr('pages.accueil.stats'),
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                alignment: Alignment.topRight,
                icon: Icon(Icons.refresh),
                iconSize: 20,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _getDocCount();
                  _getNotifUnread();
                },
              ),
            ),
          ],
        ),
        Column(
          children: _count.keys
              .toList()
              .map((key) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text(tr(key)), Text('${_count[key]}')],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  /// Affichage le cas échéant du nombre de notifications en attente sur l'icône Notification du drawer.
  Widget _myNotifIcon() {
    return Stack(
      children: <Widget>[
        Icon(Icons.notifications),
        Positioned(
          right: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(minWidth: 12, minHeight: 12),
            child: Text(
              _count['pages.accueil.notifUnread'].toString(),
              style: TextStyle(color: Colors.white, fontSize: 8),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  /// Récupération des informations sur les documents de la BDD.
  _getDocCount() async {
    _count['pages.accueil.docRead'] = await DbHelper.db.getNbResultRead();
    _count['pages.accueil.docUnread'] = await DbHelper.db.getNbResultUnread();
    _count['pages.accueil.docTotal'] = await DbHelper.db.getNbResult();
    setState(() {});
  }

  /// Récupération du nombre de notifications en attente.
  _getNotifUnread() async {
    int count = await DbHelper.db.getNbNotifUnread();
    setState(() => _count['pages.accueil.notifUnread'] = count);
  }

  /// Méthode pour actualiser les notifications depuis la page NotificationListe.
  refreshNotif() => _getNotifUnread();

  /// Récupération des détails utilisateur.
  _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_prefs.containsKey('boolLog')) {
        _log = _prefs.getBool('boolLog');
        if (_log == true) {
          _user = _prefs.getString('user');
        }
      }
      return _log;
    });
  }

  /// Récupération nom utilisateur.
  _helloUser() {
    String txt;
    setState(() {
      _log == true
          ? txt = tr('pages.accueil.hello', args: [_user])
          : txt = tr('pages.accueil.inconnu');
    });
    return txt;
  }

  /// Méthode pour se déconnecter et revenir à l'écran inital de l'application.
  _logout() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('boolLog', false);
    _prefs.remove('id');
    _prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(
        context, '/connexion', (Route<dynamic> route) => false);
  }
}
