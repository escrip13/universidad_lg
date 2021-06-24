// To parse this JSON data, do
//
//     final ranking = rankingFromJson(jsonString);

import 'dart:convert';

Ranking rankingFromJson(String str) => Ranking.fromJson(json.decode(str));

String rankingToJson(Ranking data) => json.encode(data.toJson());

class Ranking {
  Ranking({
    this.status,
  });

  Status status;

  factory Ranking.fromJson(Map<String, dynamic> json) => Ranking(
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
      };
}

class Status {
  Status({
    this.type,
    this.code,
    this.message,
    this.data,
  });

  String type;
  int code;
  String message;
  List<Datum> data;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.nombre,
    this.oro,
    this.plata,
    this.bronce,
    this.puntaje,
    this.totalMedallas,
    this.uri,
  });

  String nombre;
  int oro;
  int plata;
  int bronce;
  int puntaje;
  int totalMedallas;
  String uri;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        nombre: json["nombre"],
        oro: json["oro"],
        plata: json["plata"],
        bronce: json["bronce"],
        puntaje: json["puntaje"],
        totalMedallas: json["total_medallas"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "oro": oro,
        "plata": plata,
        "bronce": bronce,
        "puntaje": puntaje,
        "total_medallas": totalMedallas,
        "uri": uri,
      };
}
