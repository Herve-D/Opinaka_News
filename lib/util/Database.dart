import 'dart:io';
import 'package:opinakanews/model/User.dart';
import 'package:opinakanews/model/MyNotification.dart';
import 'package:opinakanews/model/RequestResult.dart';
import 'package:opinakanews/model/Request.dart';
import 'package:opinakanews/model/Result.dart';
import 'package:opinakanews/model/CustomTheme.dart';
import 'file:///E:/Stage/Projets/OpinakaNews/opinaka_news/lib/model/EnumCategorie.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Examples.dart';
import 'MyTheme.dart';

/// Classe de création et d'accès à la BDD.
class DbHelper {
  DbHelper._();

  static final DbHelper db = DbHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  /// Initialisation de la BDD si non existante.
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Opinews.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _onCreate);
  }

  /// Création des tables et éventuels inserts en dur.
  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE table_user ("
        "id_user INTEGER PRIMARY KEY AUTOINCREMENT, "
        "login TEXT, "
        "password TEXT"
        ")");
    await db.execute("CREATE TABLE table_request ("
        "id_request INTEGER PRIMARY KEY, "
        "id_user INTEGER, "
        "name_request TEXT, "
        "description_request TEXT, "
        "active TEXT, "
        "refresh_date TEXT"
        ")");
    await db.execute("CREATE TABLE table_results ("
        "id_result INTEGER PRIMARY KEY AUTOINCREMENT, "
        "content_detail TEXT, " // html
        "content_resume TEXT, " // html
        "categorie TEXT, "
        "date TEXT, "
        "latitude TEXT, "
        "longitude TEXT, "
        "status TEXT, "
        "lu INTEGER DEFAULT 0"
        ")");
    await db.execute("CREATE TABLE table_request_results ("
        "id_request INTEGER PRIMARY KEY AUTOINCREMENT, "
        "id_result INTEGER UNIQUE, "
        "status TEXT"
        ")");
    await db.execute("CREATE TABLE table_themes ("
        "theme_name TEXT PRIMARY KEY, "
        "primary_color INTEGER, "
        "primary_color_dark INTEGER, "
        "secondary_color INTEGER, "
        "secondary_color_dark INTEGER, "
        "background INTEGER, "
        "text_color INTEGER"
        ")");
    await db.execute("CREATE TABLE table_notifications ("
        "id_notification INTEGER PRIMARY KEY AUTOINCREMENT, "
        "date TEXT, "
        "nom TEXT, "
        "lu INTEGER DEFAULT 0"
        ")");
    await db.execute("CREATE TABLE table_apps ("
        "id_app INTEGER PRIMARY KEY, "
        "nom_app TEXT, "
        "description_app TEXT"
        ")");

    // Insert en dur d'un user pour faciliter le debug.
    await db.rawInsert(
        "INSERT INTO table_user(login, password) VALUES (?, ?)", ['rv', 'rv']);

    // Insert en dur des 2 thèmes de base.
    await db.rawInsert(
        "INSERT INTO table_themes(theme_name, primary_color, primary_color_dark,"
        "secondary_color, secondary_color_dark, background, text_color)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          'defaultLight',
          primaryColor.value,
          primaryColorDark.value,
          secondaryColor.value,
          secondaryColorDark.value,
          background.value,
          textColor.value
        ]);
    await db.rawInsert(
        "INSERT INTO table_themes(theme_name, primary_color, primary_color_dark,"
        "secondary_color, secondary_color_dark, background, text_color)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          'defaultDark',
          darkPrimaryColor.value,
          darkPrimaryColorDark.value,
          darkSecondaryColor.value,
          darkSecondaryColorDark.value,
          darkBackground.value,
          darkText.value
        ]);

    // Insert en dur de quelques exemples pour les tests.
    await db.rawInsert(
        "INSERT INTO table_results(content_detail, content_resume, categorie, date, latitude, longitude, status)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          html2,
          html1,
          enumToString(Categorie.emploi),
          DateTime.now().toString(),
          '48.858296',
          '2.294479',
          'Exemple'
        ]);
    await db.rawInsert(
        "INSERT INTO table_results(content_detail, content_resume, categorie, date, latitude, longitude, status)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          html4,
          html3,
          enumToString(Categorie.loisirs),
          DateTime(2020, 06, 05, 12, 30).toString(),
          '44.837912',
          '-0.579541',
          'Disponible'
        ]);
    await db.rawInsert(
        "INSERT INTO table_results(content_detail, content_resume, categorie, date, latitude, longitude, status)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          html6,
          html5,
          enumToString(Categorie.emploi),
          DateTime(2020, 06, 01, 13, 47).toString(),
          '45.759723',
          '4.842223',
          'Informations'
        ]);
    await db.rawInsert(
        "INSERT INTO table_results(content_detail, content_resume, categorie, date, latitude, longitude, status)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          html8,
          html7,
          enumToString(Categorie.multimedia),
          DateTime.now().toString(),
          '47.247500',
          '1.353333',
          'En stock'
        ]);
    await db.rawInsert(
        "INSERT INTO table_results(content_detail, content_resume, categorie, date, latitude, longitude, status)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          html10,
          html9,
          enumToString(Categorie.sport),
          DateTime(2020, 06, 10, 08, 56).toString(),
          '48.390834',
          '-4.485556',
          'Apprentissage'
        ]);
    await db.rawInsert(
        "INSERT INTO table_results(content_detail, content_resume, categorie, date, latitude, longitude, status)"
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          html12,
          html11,
          enumToString(Categorie.emploi),
          DateTime.now().toString(),
          '48.850800',
          '2.589900',
          'Indisponible'
        ]);
  }

  // Méthodes pour la table User.
  addUser(User user) async {
    final db = await database;
    var raw = await db.insert("table_user", user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<User> getUser(String user) async {
    var db = await database;
    var res =
        await db.query("table_user", where: "login = ?", whereArgs: [user]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("table_user");
    List<User> liste = res.map((c) => User.fromMap(c)).toList();
    return liste;
  }

  suppUser(int id) async {
    final db = await database;
    return db.delete("table_user", where: "id_user = ?", whereArgs: [id]);
  }

  // Méthodes pour la table Result.
  addResult(Result result) async {
    final db = await database;
    var raw = await db.insert("table_results", result.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<Result>> getResultByCat(String categorie) async {
    final db = await database;
    var res = await db
        .query("table_results", where: "categorie = ?", whereArgs: [categorie]);
    List<Result> liste = res.map((c) => Result.fromMap(c)).toList();
    return liste;
  }

  Future<List<Result>> getAllResults() async {
    final db = await database;
    var res = await db.query("table_results");
    List<Result> liste = res.map((c) => Result.fromMap(c)).toList();
    return liste;
  }

  Future<int> getNbResult() async {
    var db = await database;
    var res = await db.rawQuery("SELECT COUNT(*) FROM table_results");
    int count = Sqflite.firstIntValue(res);
    return count;
  }

  Future<int> getNbResultUnread() async {
    var db = await database;
    var res =
        await db.rawQuery("SELECT COUNT(lu) FROM table_results WHERE lu = 0");
    int count = Sqflite.firstIntValue(res);
    return count;
  }

  Future<int> getNbResultRead() async {
    var db = await database;
    var res =
        await db.rawQuery("SELECT COUNT(lu) FROM table_results WHERE lu = 1");
    int count = Sqflite.firstIntValue(res);
    return count;
  }

  updateResult(Result result) async {
    final db = await database;
    var res = await db.update("table_results", result.toMap(),
        where: "id_result = ?", whereArgs: [result.idResult]);
    return res;
  }

  // Méthodes pour la table Request.
  addRequest(Request request) async {
    final db = await database;
    var raw = await db.insert("table_request", request.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<Request>> getAllRequest(int idUser) async {
    final db = await database;
    var res = await db
        .query("table_request", where: "id_user = ?", whereArgs: [idUser]);
    List<Request> liste = res.map((c) => Request.fromMap(c)).toList();
    return liste;
  }

  suppRequest(int id) async {
    final db = await database;
    return db.delete("table_request", where: "id_request = ?", whereArgs: [id]);
  }

  // Méthodes pour la table Request_Result.
  addRequestResult(int idResult) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT INTO table_request_results("
        "id_result) VALUES (?)",
        [idResult]);
    return raw;
  }

  Future<RequestResult> getRequestResultByResult(int idResult) async {
    var db = await database;
    var res = await db.query("table_request_results",
        where: "id_result = ?", whereArgs: [idResult]);
    return res.isNotEmpty ? RequestResult.fromMap(res.first) : null;
  }

  Future<List<int>> getAllRequestResultByIdResult() async {
    final db = await database;
    var res = await db.query("table_request_results", columns: ["id_result"]);
    List<RequestResult> liste =
        res.map((c) => RequestResult.fromMapIdRes(c)).toList();
    List<int> listeInt = liste.map((e) => e.idResult).toList();
    return listeInt;
  }

  suppRequestResult(int idReq) async {
    final db = await database;
    return db.delete("table_request_results",
        where: "id_request = ?", whereArgs: [idReq]);
  }

  // Méthode pour la table Theme.
  addTheme(CustomTheme theme) async {
    final db = await database;
    var raw = await db.insert("table_themes", theme.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  updateTheme(CustomTheme theme) async {
    final db = await database;
    var res = await db.update("table_themes", theme.toMap(),
        where: "theme_name = ?", whereArgs: [theme.themeName]);
    return res;
  }

  Future<CustomTheme> getTheme(String theme) async {
    var db = await database;
    var res = await db
        .query("table_themes", where: "theme_name = ?", whereArgs: [theme]);
    return res.isNotEmpty ? CustomTheme.fromMap(res.first) : null;
  }

  Future<List<CustomTheme>> getAllTheme() async {
    final db = await database;
    var res = await db.query("table_themes");
    List<CustomTheme> liste = res.map((c) => CustomTheme.fromMap(c)).toList();
    return liste;
  }

  suppTheme(String theme) async {
    final db = await database;
    return db
        .delete("table_themes", where: "theme_name = ?", whereArgs: [theme]);
  }

  // Méthodes pour la table Notification.
  addNotification(MyNotification notification) async {
    final db = await database;
    var raw = await db.insert("table_notifications", notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<MyNotification>> getAllNotifications() async {
    final db = await database;
    var res = await db.query("table_notifications");
    List<MyNotification> liste =
        res.map((c) => MyNotification.fromMap(c)).toList();
    return liste;
  }

  Future<int> getNbNotifUnread() async {
    var db = await database;
    var res = await db
        .rawQuery("SELECT COUNT(lu) FROM table_notifications WHERE lu = 0");
    int count = Sqflite.firstIntValue(res);
    return count;
  }

  updateNotification(MyNotification notification) async {
    final db = await database;
    var res = await db.update("table_notifications", notification.toMap(),
        where: "id_notification = ?", whereArgs: [notification.idNotification]);
    return res;
  }

  suppNotification(int id) async {
    final db = await database;
    return db.delete("table_notifications",
        where: "id_notification = ?", whereArgs: [id]);
  }
}
