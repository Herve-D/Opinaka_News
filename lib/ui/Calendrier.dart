import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:opinakanews/model/RequestResult.dart';
import 'package:opinakanews/model/Request.dart';
import 'package:opinakanews/model/Result.dart';
import 'package:opinakanews/util/Database.dart';
import 'package:opinakanews/util/ListeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

/// Page affichant un calendrier afin de consulter les documents par dates.
class Calendrier extends StatefulWidget {
  @override
  _CalendrierState createState() => _CalendrierState();
}

class _CalendrierState extends State<Calendrier> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  int user;
  bool isLog = false;
  List<int> _listeFavorites;
  CalendarController _calendarController;
  AnimationController _animationController;
  List _selectedNews;
  Map<DateTime, List> _news;

  void _onDaySelected(DateTime day, List news) {
    setState(() {
      _selectedNews = news;
    });
  }

  @override
  void initState() {
    _getPrefs();
    _getFavorite();
//    final _selectedDay = DateTime.now();
    _selectedNews = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNews().then((value) => setState(() {
            _news = value;
          }));
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.calendrier')),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTableCalendar(),
            const SizedBox(height: 10.0),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  /// Construction du calendrier avec ses différentes configurations.
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _news,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        titleTextBuilder: (date, locale) => DateFormat.yM(locale).format(date),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              color: Theme.of(context).accentColor,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(5.0),
            color: Theme.of(context).colorScheme.secondaryVariant,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, news, _) {
          final children = <Widget>[];
          if (news.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildNewsMarker(date, news),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, news) {
        _onDaySelected(date, news);
        _animationController.forward(from: 0.0);
      },
    );
  }

  /// Construction des indicateurs de nombre de documents par dates sur le calendrier.
  Widget _buildNewsMarker(DateTime date, List news) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _calendarController.isSelected(date)
              ? Theme.of(context).primaryColor
              : _calendarController.isToday(date)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.primaryVariant),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text('${news.length}',
            style: TextStyle().copyWith(
                color: Theme.of(context).backgroundColor, fontSize: 12.0)),
      ),
    );
  }

  /// Construction de la liste de documents pour une date sélectionnée.
  Widget _buildNewsList() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: _selectedNews
          .map((news) => myListWidget(
                context: context,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Text(news.idResult.toString()),
                  ),
                  title: Html(data: news.resume),
                  children: <Widget>[
                    ListTile(
                      leading: IconButton(
                        icon: Icon(
                          isLog && _listeFavorites.contains(news.idResult)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          _setFavorite(news);
                        },
                      ),
                      subtitle: Text(news.status),
                      trailing: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          Result.readView(context, news);
                        },
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  /// Récupération des documents et tri par dates.
  Future<Map<DateTime, List>> getNews() async {
    Map<DateTime, List> mapFetch = {};
    List<Result> news = await DbHelper.db.getAllResults();
    for (int i = 0; i < news.length; i++) {
      var date =
          DateTime(news[i].date.year, news[i].date.month, news[i].date.day);
      var original = mapFetch[date];
      if (original == null) {
        mapFetch[date] = [news[i]];
      } else {
        mapFetch[date] = List.from(original)..addAll([news[i]]);
      }
    }
    return mapFetch;
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
