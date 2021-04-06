import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/model/MyNotification.dart';
import 'package:opinakanews/util/Database.dart';

/// Page listant les notifications.
class NotificationListe extends StatefulWidget {
  /// Récupération de la méthode refreshNotif de la page Accueil.
  final Function() updateUnread;

  NotificationListe({Key key, this.updateUnread}) : super(key: key);

  @override
  _NotificationListeState createState() => _NotificationListeState();
}

class _NotificationListeState extends State<NotificationListe> {
  DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");
  int _test = 0;

  void _noTest() {
    setState(() {
      _test++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.notifListe')),
        actions: <Widget>[
          RaisedButton(
              child: Text('TEST'),
              onPressed: () {
                _noTest();
                DbHelper.db.addNotification(new MyNotification(
                    date: DateTime.now(), nom: 'Test $_test', lu: false));
                setState(() {});
                widget.updateUnread();
              })
        ],
      ),
      body: FutureBuilder<List<MyNotification>>(
        future: DbHelper.db.getAllNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                MyNotification item = snapshot.data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.lu ? Colors.green : Colors.red,
                  ),
                  title: Text(item.nom),
                  subtitle: Text(_format.format(item.date)),
                  trailing: PopupMenuButton(
                    onSelected: (dynamic value) {
                      setState(() {
                        DbHelper.db.suppNotification(value);
                      });
                      widget.updateUnread();
                    },
                    elevation: 20.0,
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).accentColor,
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor, width: 1.5),
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Theme.of(context).primaryColor,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: item.idNotification,
                        child: Text(tr('del')),
                      )
                    ],
                  ),
                  onTap: () {
                    if (!item.lu) {
                      item.lu = true;
                      DbHelper.db.updateNotification(item);
                      widget.updateUnread();
                    }
                    Navigator.pushNamed(context, '/notifDetails',
                        arguments: item);
                  },
                );
              },
            );
          } else {
            return Center(
                child: Text(tr('pages.notifications.default'),
                    style: TextStyle(fontStyle: FontStyle.italic)));
          }
        },
      ),
    );
  }
}
