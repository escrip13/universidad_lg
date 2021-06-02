// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Evaluacion welcomeFromJson(String str) => Evaluacion.fromJson(json.decode(str));

String welcomeToJson(Evaluacion data) => json.encode(data.toJson());

class Evaluacion {
  Evaluacion({
    this.status,
  });

  Status status;

  factory Evaluacion.fromJson(Map<String, dynamic> json) => Evaluacion(
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
    this.evaluaciones,
  });

  String type;
  int code;
  String message;
  List<EvaluacionItem> evaluaciones;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        evaluaciones: List<EvaluacionItem>.from(
            json["evaluaciones"].map((x) => EvaluacionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "evaluaciones": List<dynamic>.from(evaluaciones.map((x) => x.toJson())),
      };
}

class EvaluacionItem {
  EvaluacionItem({
    this.nid,
    this.title,
    this.portada,
    this.tiempo,
    this.descripcion,
    this.porcentaje,
    this.puntaje,
    this.sustitutorio,
  });

  String nid;
  String title;
  String portada;
  String tiempo;
  String descripcion;
  int porcentaje;
  dynamic puntaje;
  dynamic sustitutorio;

  factory EvaluacionItem.fromJson(Map<String, dynamic> json) => EvaluacionItem(
        nid: json["nid"],
        title: json["title"],
        portada: json["portada"],
        tiempo: json["tiempo"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        porcentaje: json["porcentaje"],
        puntaje: json["puntaje"],
        sustitutorio: json["sustitutorio"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "portada": portada,
        "tiempo": tiempo,
        "descripcion": descripcion == null ? null : descripcion,
        "porcentaje": porcentaje,
        "puntaje": puntaje,
        "sustitutorio": sustitutorio,
      };
}
