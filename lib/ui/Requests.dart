import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:opinakanews/model/Request.dart';
import 'package:opinakanews/util/Database.dart';
import 'package:opinakanews/util/ListeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page listant les documents archivés.
class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  SharedPreferences prefs;
  int user;

  @override
  void initState() {
    _getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.request')),
      ),
      body: FutureBuilder<List<Request>>(
        future: DbHelper.db.getAllRequest(user),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Request item = snapshot.data[index];
                return myListWidget(
                  context: context,
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.stars,
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                    title: Html(data: item.name),
                    trailing: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Theme.of(context).accentColor,
                    ),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.arrow_right,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        subtitle: Text(tr('pages.request.sub')),
                        onTap: () {
                          Navigator.pushNamed(context, '/view',
                              arguments: item.description);
                        },
                        trailing: PopupMenuButton(
                          onSelected: (dynamic val) {
                            DbHelper.db.suppRequest(item.idRequest);
                            DbHelper.db.suppRequestResult(item.idRequest);
                            setState(() {});
                          },
                          elevation: 20.0,
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).accentColor,
                          ),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Theme.of(context).primaryColor,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: item.name,
                              child: Center(
                                child: Text(tr('del')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text(tr('pages.request.default'),
                    style: TextStyle(fontStyle: FontStyle.italic)));
          }
        },
      ),
    );
  }

  /// Récupération détails utilisateur.
  _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getInt('id');
      return user;
    });
  }
}
