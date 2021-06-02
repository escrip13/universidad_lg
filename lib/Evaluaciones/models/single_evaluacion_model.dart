// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SingleEvaluacion welcomeFromJson(String str) =>
    SingleEvaluacion.fromJson(json.decode(str));

String welcomeToJson(SingleEvaluacion data) => json.encode(data.toJson());

class SingleEvaluacion {
  SingleEvaluacion({
    this.status,
  });

  Status status;

  factory SingleEvaluacion.fromJson(Map<String, dynamic> json) =>
      SingleEvaluacion(
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
    this.tiempo,
    this.preguntas,
  });

  String type;
  int code;
  String message;
  String tiempo;
  List<Pregunta> preguntas;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        tiempo: json["tiempo"],
        preguntas: List<Pregunta>.from(
            json["preguntas"].map((x) => Pregunta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "tiempo": tiempo,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
      };
}

class Pregunta {
  Pregunta({
    this.id,
    this.texto,
    this.correcta,
    this.tipo,
    this.respuestas,
  });

  String id;
  String texto;
  int correcta;
  int tipo;
  List<Respuesta> respuestas;

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        id: json["id"],
        texto: json["texto"],
        correcta: json["correcta"],
        tipo: json["tipo"],
        respuestas: List<Respuesta>.from(
            json["respuestas"].map((x) => Respuesta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "texto": texto,
        "correcta": correcta,
        "tipo": tipo,
        "respuestas": List<dynamic>.from(respuestas.map((x) => x.toJson())),
      };
}

class Respuesta {
  Respuesta({
    this.delta,
    this.texto,
  });

  int delta;
  String texto;

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
        delta: json["delta"],
        texto: json["texto"],
      );

  Map<String, dynamic> toJson() => {
        "delta": delta,
        "texto": texto,
      };
}
