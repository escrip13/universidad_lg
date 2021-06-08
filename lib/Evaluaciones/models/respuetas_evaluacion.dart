// To parse this JSON data, do
//
//     final respuestaEvaluacion = respuestaEvaluacionFromJson(jsonString);

import 'dart:convert';

RespuestaEvaluacion respuestaEvaluacionFromJson(String str) =>
    RespuestaEvaluacion.fromJson(json.decode(str));

String respuestaEvaluacionToJson(RespuestaEvaluacion data) =>
    json.encode(data.toJson());

class RespuestaEvaluacion {
  RespuestaEvaluacion({
    this.status,
  });

  Status status;

  factory RespuestaEvaluacion.fromJson(Map<String, dynamic> json) =>
      RespuestaEvaluacion(
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
    this.respuetas,
  });

  String type;
  int code;
  String message;
  Respuetas respuetas;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        respuetas: Respuetas.fromJson(json["respuetas"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "respuetas": respuetas.toJson(),
      };
}

class Respuetas {
  Respuetas({
    this.idCurso,
    this.items,
    this.inCorrectas,
  });

  String idCurso;
  List<Item> items;
  int inCorrectas;

  factory Respuetas.fromJson(Map<String, dynamic> json) => Respuetas(
        idCurso: json["id_curso"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        inCorrectas: json["inCorrectas"],
      );

  Map<String, dynamic> toJson() => {
        "id_curso": idCurso,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "inCorrectas": inCorrectas,
      };
}

class Item {
  Item({
    this.id,
    this.pregunta,
    this.tipo,
    this.respuesta,
  });

  String id;
  String pregunta;
  int tipo;
  List<Respuesta> respuesta;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        pregunta: json["pregunta"],
        tipo: json["tipo"],
        respuesta: List<Respuesta>.from(
            json["respuesta"].map((x) => Respuesta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pregunta": pregunta,
        "tipo": tipo,
        "respuesta": List<dynamic>.from(respuesta.map((x) => x.toJson())),
      };
}

class Respuesta {
  Respuesta({
    this.respuesta,
    this.estado,
  });

  String respuesta;
  int estado;

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
        respuesta: json["respuesta"],
        estado: json["estado"] == null ? null : json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
        "estado": estado == null ? null : estado,
      };
}
