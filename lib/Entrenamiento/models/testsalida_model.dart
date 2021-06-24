// To parse this JSON data, do
//
//     final testSalida = testSalidaFromJson(jsonString);

import 'dart:convert';

TestSalida testSalidaFromJson(String str) =>
    TestSalida.fromJson(json.decode(str));

String testSalidaToJson(TestSalida data) => json.encode(data.toJson());

class TestSalida {
  TestSalida({
    this.status,
  });

  Status status;

  factory TestSalida.fromJson(Map<String, dynamic> json) => TestSalida(
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
    this.encuestas,
  });

  String type;
  int code;
  String message;
  String tiempo;
  List<StatusPregunta> preguntas;
  Encuestas encuestas;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        tiempo: json["tiempo"],
        preguntas: List<StatusPregunta>.from(
            json["preguntas"].map((x) => StatusPregunta.fromJson(x))),
        encuestas: Encuestas.fromJson(json["encuestas"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "tiempo": tiempo,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
        "encuestas": encuestas.toJson(),
      };
}

class Encuestas {
  Encuestas({
    this.titulo,
    this.preguntas,
  });

  String titulo;
  List<EncuestasPregunta> preguntas;

  factory Encuestas.fromJson(Map<String, dynamic> json) => Encuestas(
        titulo: json["titulo"],
        preguntas: List<EncuestasPregunta>.from(
            json["preguntas"].map((x) => EncuestasPregunta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
      };
}

class EncuestasPregunta {
  EncuestasPregunta({
    this.tipo,
    this.idPregunta,
    this.pregunta,
    this.respuesta,
  });

  String tipo;
  String idPregunta;
  String pregunta;
  List<String> respuesta;

  factory EncuestasPregunta.fromJson(Map<String, dynamic> json) =>
      EncuestasPregunta(
        tipo: json["tipo"],
        idPregunta: json["id_pregunta"],
        pregunta: json["pregunta"],
        respuesta: json["respuesta"] == null
            ? null
            : List<String>.from(json["respuesta"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "id_pregunta": idPregunta,
        "pregunta": pregunta,
        "respuesta": respuesta == null
            ? null
            : List<dynamic>.from(respuesta.map((x) => x)),
      };
}

class StatusPregunta {
  StatusPregunta({
    this.id,
    this.texto,
    this.correcta,
    this.tipo,
    this.respuestas,
  });

  String id;
  String texto;
  String correcta;
  int tipo;
  List<Respuesta> respuestas;

  factory StatusPregunta.fromJson(Map<String, dynamic> json) => StatusPregunta(
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
