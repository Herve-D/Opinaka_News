/// Classe faisant la relation entre les Resultats et les Requêtes.
class RequestResult {
  int idRequest;
  int idResult;
  String status;

  RequestResult({this.idRequest, this.idResult, this.status});

  factory RequestResult.fromMap(Map<String, dynamic> data) => new RequestResult(
        idRequest: data['id_request'],
        idResult: data['id_result'],
        status: data['status'],
      );

  factory RequestResult.fromMapIdRes(Map<String, dynamic> data) =>
      new RequestResult(
        idResult: data['id_result'],
      );

  Map<String, dynamic> toMap() => {
        "id_request": idRequest,
        "id_result": idResult,
        "status": status,
      };
}
