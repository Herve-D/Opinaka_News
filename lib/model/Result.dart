import 'package:flutter/material.dart';
import 'package:opinakanews/util/Database.dart';

/// Classe des Résultats provenant de la BDD.
class Result {
  int idResult;
  String detail;
  String resume;
  String categorie;
  DateTime date;
  String lat;
  String long;
  String status;
  bool lu;

  Result({
    this.idResult,
    this.detail,
    this.resume,
    this.categorie,
    this.date,
    this.lat,
    this.long,
    this.status,
    this.lu,
  });

  factory Result.fromMap(Map<String, dynamic> data) => new Result(
        idResult: data['id_result'],
        detail: data['content_detail'],
        resume: data['content_resume'],
        categorie: data['categorie'],
        date: DateTime.tryParse(data['date']),
        lat: data['latitude'],
        long: data['longitude'],
        status: data['status'],
        lu: data['lu'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        "id_result": idResult,
        "content_detail": detail,
        "content_resume": resume,
        "categorie": categorie,
        "date": date.toString(),
        "latitude": lat,
        "longitude": long,
        "status": status,
        "lu": lu == true ? 1 : 0,
      };

  /// Méthode pour accéder aux détails Html d'un Résultat ainsi que la MAJ "lu" le cas échéant.
  static readView(BuildContext context, Result result) async {
    if (!result.lu) {
      result.lu = true;
      DbHelper.db.updateResult(result);
    }
    Navigator.pushNamed(context, '/view', arguments: result.detail);
  }
}
