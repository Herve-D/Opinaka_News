import 'package:flutter/material.dart';

/// Widget personnalisé utilisé pour les listes.
Widget myListWidget({BuildContext context, Widget child}) {
  return Container(
    child: child,
    decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor,
              offset: Offset(5.0, 5.0),
              blurRadius: 10.0)
        ]),
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    padding: EdgeInsets.all(5.0),
  );
}
