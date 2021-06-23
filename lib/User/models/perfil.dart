// To parse this JSON data, do
//
//     final perfil = perfilFromJson(jsonString);

import 'dart:convert';

Perfil perfilFromJson(String str) => Perfil.fromJson(json.decode(str));

String perfilToJson(Perfil data) => json.encode(data.toJson());

class Perfil {
  Perfil({
    this.status,
  });

  Status status;

  factory Perfil.fromJson(Map<String, dynamic> json) => Perfil(
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
  Data data;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.imagen,
    this.totalpuntos,
    this.oro,
    this.plata,
    this.bronce,
  });

  String imagen;
  int totalpuntos;
  int oro;
  int plata;
  int bronce;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        imagen: json["imagen"],
        totalpuntos: json["totalpuntos"],
        oro: json["oro"],
        plata: json["plata"],
        bronce: json["bronce"],
      );

  Map<String, dynamic> toJson() => {
        "imagen": imagen,
        "totalpuntos": totalpuntos,
        "oro": oro,
        "plata": plata,
        "bronce": bronce,
      };
}
