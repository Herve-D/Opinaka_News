import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/model/User.dart';
import 'package:opinakanews/util/Database.dart';

/// Liste des utilisateurs enregistrés (utilisée principalement pour les tests/debug).
class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pageNames.logins')),
      ),
      body: FutureBuilder<List<User>>(
        future: DbHelper.db.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                User item = snapshot.data[index];
                return ListTile(
                  leading: FlutterLogo(),
                  title: Text(tr('pages.logins.logTitre', args: [item.login])),
                  subtitle: Text("ID : ${item.idUser.toString()}"),
                  trailing: PopupMenuButton(
                    onSelected: (dynamic value) {
                      setState(() {
                        DbHelper.db.suppUser(value);
                      });
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
                        value: item.idUser,
                        child: Text(tr('del')),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
