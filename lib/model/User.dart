/// Classe Utilisateur
class User {
  int idUser;
  String login;
  String password;

  User({this.idUser, this.login, this.password});

  factory User.fromMap(Map<String, dynamic> data) => new User(
        idUser: data['id_user'],
        login: data['login'],
        password: data['password'],
      );

  Map<String, dynamic> toMap() => {
        "id_user": idUser,
        "login": login,
        "password": password,
      };
}
