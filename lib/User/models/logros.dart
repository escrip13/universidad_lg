// To parse this JSON data, do
//
//     final logros = logrosFromJson(jsonString);

import 'dart:convert';

Logros logrosFromJson(String str) => Logros.fromJson(json.decode(str));

String logrosToJson(Logros data) => json.encode(data.toJson());

class Logros {
  Logros({
    this.status,
  });

  Status status;

  factory Logros.fromJson(Map<String, dynamic> json) => Logros(
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
    this.uid,
    this.nid,
    this.titulo,
    this.cuerpo,
    this.porcentaje,
    this.medalla,
  });

  String uid;
  String nid;
  String titulo;
  String cuerpo;
  String porcentaje;
  String medalla;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        uid: json["uid"],
        nid: json["nid"],
        titulo: json["titulo"],
        cuerpo: json["cuerpo"],
        porcentaje: json["porcentaje"],
        medalla: json["medalla"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "nid": nid,
        "titulo": titulo,
        "cuerpo": cuerpo,
        "porcentaje": porcentaje,
        "medalla": medalla,
      };
}
