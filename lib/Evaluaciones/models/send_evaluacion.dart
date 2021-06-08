// To parse this JSON data, do
//
//     final sendEvaluacion = sendEvaluacionFromJson(jsonString);

import 'dart:convert';

SendEvaluacion sendEvaluacionFromJson(String str) =>
    SendEvaluacion.fromJson(json.decode(str));

String sendEvaluacionToJson(SendEvaluacion data) => json.encode(data.toJson());

class SendEvaluacion {
  SendEvaluacion({
    this.status,
  });

  Status status;

  factory SendEvaluacion.fromJson(Map<String, dynamic> json) => SendEvaluacion(
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
    this.evaluacionRest,
  });

  String type;
  int code;
  String message;
  EvaluacionRest evaluacionRest;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        evaluacionRest: EvaluacionRest.fromJson(json["evaluacionRest"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "evaluacionRest": evaluacionRest.toJson(),
      };
}

class EvaluacionRest {
  EvaluacionRest({
    this.sustituto,
    this.copa,
    this.puntaje,
    this.titulo,
  });

  int sustituto;
  String copa;
  int puntaje;
  String titulo;

  factory EvaluacionRest.fromJson(Map<String, dynamic> json) => EvaluacionRest(
        sustituto: json["sustituto"],
        copa: json["copa"],
        puntaje: json["puntaje"],
        titulo: json["titulo"],
      );

  Map<String, dynamic> toJson() => {
        "sustituto": sustituto,
        "copa": copa,
        "puntaje": puntaje,
        "titulo": titulo,
      };
}
