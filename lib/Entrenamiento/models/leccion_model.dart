// To parse this JSON data, do
//
//     final leccion = leccionFromJson(jsonString);

import 'dart:convert';

Leccion leccionFromJson(String str) => Leccion.fromJson(json.decode(str));

String leccionToJson(Leccion data) => json.encode(data.toJson());

class Leccion {
  Leccion({
    this.status,
  });

  Status status;

  factory Leccion.fromJson(Map<String, dynamic> json) => Leccion(
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
    this.curso,
  });

  Curso curso;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        curso: Curso.fromJson(json["curso"]),
      );

  Map<String, dynamic> toJson() => {
        "curso": curso.toJson(),
      };
}

class Curso {
  Curso({
    this.titulo,
    this.tipo,
    this.tipoDocumento,
    this.datos,
    this.datosmulti,
    this.sig,
    this.url,
    this.pos,
    this.bodyValue,
    this.uri,
  });

  String titulo;
  String tipo;
  String tipoDocumento;
  String datos;
  List<String> datosmulti;
  dynamic sig;
  String url;
  String pos;
  String bodyValue;
  String uri;

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        titulo: json["titulo"],
        tipo: json["tipo"],
        tipoDocumento: json["tipo_documento"],
        datos: json["datos"],
        datosmulti: List<String>.from(json["datosmulti"].map((x) => x)),
        sig: json["sig"],
        url: json["url"],
        pos: json["pos"],
        bodyValue: json["body_value"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "tipo": tipo,
        "tipo_documento": tipoDocumento,
        "datos": datos,
        "datosmulti": List<dynamic>.from(datosmulti.map((x) => x)),
        "sig": sig,
        "url": url,
        "pos": pos,
        "body_value": bodyValue,
        "uri": uri,
      };
}
