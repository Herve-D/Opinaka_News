import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/model/MyNotification.dart';

/// Page de détails d'une notification.
class NotificationDetails extends StatefulWidget {
  final MyNotification notification;

  NotificationDetails({Key key, this.notification}) : super(key: key);

  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.notifDetails')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.notification.nom),
            Text(_format.format(widget.notification.date))
          ],
        ),
      ),
    );
  }
}
