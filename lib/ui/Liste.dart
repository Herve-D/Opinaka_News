import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:opinakanews/model/RequestResult.dart';
import 'package:opinakanews/model/Request.dart';
import 'package:opinakanews/model/Result.dart';
import 'package:opinakanews/util/Database.dart';
import 'package:opinakanews/util/ListeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page listant les résultats de documents provenant de la BDD.
class ListeBoucle extends StatefulWidget {
  @override
  _ListeBoucleState createState() => _ListeBoucleState();
}

class _ListeBoucleState extends State<ListeBoucle> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  int user;
  bool isLog = false;
  List<int> _listeFavorites;
  DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");
  List<Result> _news = [];

  @override
  void initState() {
    _getPrefs();
    _getFavorite();
    _getNews().then((value) => setState(() {
          _news = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.liste')),
      ),
      key: scaffoldKey,
      body: ListView.builder(
        itemCount: _news.length,
        itemBuilder: (context, index) {
          Result item = _news[index];
          return myListWidget(
            context: context,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Text(item.idResult.toString()),
              ),
              title: Html(data: item.resume),
              subtitle: Text(
                _format.format(item.date),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                ListTile(
                  leading: IconButton(
                    icon: Icon(
                      isLog && _listeFavorites.contains(item.idResult)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      _setFavorite(item);
                    },
                  ),
                  subtitle: Text(item.status),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      Result.readView(context, item);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Récupération des Résultats et tri des services abonnés le cas échéant.
  Future<List<Result>> _getNews() async {
    List<Result> listFetch = [];
    prefs = await SharedPreferences.getInstance();
    List<String> services = [];
    if (prefs.containsKey('services')) {
      services = prefs.getStringList('services');
    }
    if (services.isNotEmpty) {
      for (int i = 0; i < services.length; i++) {
        List<Result> tmp = await DbHelper.db.getResultByCat(services[i]);
        listFetch.addAll(tmp);
      }
    } else {
      listFetch = await DbHelper.db.getAllResults();
    }
    return listFetch;
  }

  /// Méthode pour ajouter/retirer des archives.
  _setFavorite(Result item) async {
    if (isLog) {
      if (!_isFavorite(item)) {
        await DbHelper.db.addRequestResult(item.idResult);
        RequestResult tmp = await DbHelper.db.getRequestResultByResult(item.idResult);
        await DbHelper.db.addRequest(new Request(
            idRequest: tmp.idRequest,
            idUser: user,
            name: item.resume,
            description: item.detail,
            active: 'null',
            refreshDate: 'null'));
        _listeFavorites.add(item.idResult);
        _showSnack(tr('pages.liste.snackAdd'));
      } else {
        RequestResult tmp = await DbHelper.db.getRequestResultByResult(item.idResult);
        await DbHelper.db.suppRequestResult(tmp.idRequest);
        await DbHelper.db.suppRequest(tmp.idRequest);
        _listeFavorites.remove(item.idResult);
        _showSnack(tr('pages.liste.snackLess'));
      }
      setState(() {});
    } else {
      _dialogLogin();
    }
  }

  /// Méthode pour vérifier l'état d'archive.
  _isFavorite(Result item) {
    return _listeFavorites.contains(item.idResult) ? true : false;
  }

  /// Récupération des documents archivés.
  _getFavorite() async {
    _listeFavorites = await DbHelper.db.getAllRequestResultByIdResult();
  }

  /// Récupération des détails utilisateur.
  _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('boolLog')) {
        isLog = prefs.getBool('boolLog');
        if (isLog == true) {
          user = prefs.getInt('id');
        }
      }
      return user;
    });
  }

  /// Bandeau personnalisable au bas de la page.
  void _showSnack(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ).tr(),
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      elevation: 10.0,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ));
  }

  /// Boîte de dialogue.
  Future<void> _dialogLogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(tr('pages.liste.dialLogin')),
          content: SingleChildScrollView(
            child: Text(tr('pages.liste.dialMsg')),
          ),
          shape: RoundedRectangleBorder(
              side:
                  BorderSide(color: Theme.of(context).accentColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.0)),
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
}
