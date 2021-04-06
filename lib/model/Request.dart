/// Classe des Requêtes de l'utilisateur.
class Request {
  int idRequest;
  int idUser;
  String name;
  String description;
  String active;
  String refreshDate;

  Request(
      {this.idRequest,
      this.idUser,
      this.name,
      this.description,
      this.active,
      this.refreshDate});

  factory Request.fromMap(Map<String, dynamic> data) => new Request(
        idRequest: data['id_request'],
        idUser: data['id_user'],
        name: data['name_request'],
        description: data['description_request'],
        active: data['active'],
        refreshDate: data['refresh_date'],
      );

  Map<String, dynamic> toMap() => {
        "id_request": idRequest,
        "id_user": idUser,
        "name_request": name,
        "description_request": description,
        "active": active,
        "refresh_date": refreshDate,
      };
}
