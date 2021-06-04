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
    this.restEvaluacion,
  });

  String type;
  int code;
  String message;
  RestEvaluacion restEvaluacion;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        restEvaluacion: RestEvaluacion.fromJson(json["restEvaluacion"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "restEvaluacion": restEvaluacion.toJson(),
      };
}

class RestEvaluacion {
  RestEvaluacion({
    this.sustituto,
    this.copa,
    this.puntaje,
    this.titulo,
  });

  int sustituto;
  String copa;
  int puntaje;
  String titulo;

  factory RestEvaluacion.fromJson(Map<String, dynamic> json) => RestEvaluacion(
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
