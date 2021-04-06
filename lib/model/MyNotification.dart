/// Classe pour les notifications.
class MyNotification {
  int idNotification;
  DateTime date;
  String nom;
  bool lu;

  MyNotification({
    this.idNotification,
    this.date,
    this.nom,
    this.lu,
  });

  factory MyNotification.fromMap(Map<String, dynamic> data) =>
      new MyNotification(
        idNotification: data['id_notification'],
        date: DateTime.tryParse(data['date']),
        nom: data['nom'],
        lu: data['lu'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        "id_notification": idNotification,
        "date": date.toString(),
        "nom": nom,
        "lu": lu == true ? 1 : 0,
      };
}
