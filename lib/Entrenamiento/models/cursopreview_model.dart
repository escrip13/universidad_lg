// To parse this JSON data, do
//
//     final cursoPreview = cursoPreviewFromJson(jsonString);

import 'dart:convert';

CursoPreview cursoPreviewFromJson(String str) =>
    CursoPreview.fromJson(json.decode(str));

String cursoPreviewToJson(CursoPreview data) => json.encode(data.toJson());

class CursoPreview {
  CursoPreview({
    this.status,
  });

  Status status;

  factory CursoPreview.fromJson(Map<String, dynamic> json) => CursoPreview(
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
    this.leccionId,
    this.testEntrada,
    this.testTiempo,
    this.sustitutorio,
    this.puntaje,
    this.testSalida,
    this.verCurso,
  });

  Curso curso;
  String leccionId;
  int testEntrada;
  String testTiempo;
  int sustitutorio;
  int puntaje;
  int testSalida;
  int verCurso;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        curso: Curso.fromJson(json["curso"]),
        leccionId: json["leccion_id"],
        testEntrada: json["test_entrada"],
        testTiempo: json["test_tiempo"],
        sustitutorio: json["sustitutorio"],
        puntaje: json["puntaje"],
        testSalida: json["test_salida"],
        verCurso: json["ver_curso"],
      );

  Map<String, dynamic> toJson() => {
        "curso": curso.toJson(),
        "leccion_id": leccionId,
        "test_entrada": testEntrada,
        "test_tiempo": testTiempo,
        "sustitutorio": sustitutorio,
        "puntaje": puntaje,
        "test_salida": testSalida,
        "ver_curso": verCurso,
      };
}

class Curso {
  Curso({
    this.nid,
    this.title,
    this.uri,
    this.bodyValue,
    this.video,
  });

  String nid;
  String title;
  String uri;
  String bodyValue;
  String video;

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        nid: json["nid"],
        title: json["title"],
        uri: json["uri"],
        bodyValue: json["body_value"],
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "uri": uri,
        "body_value": bodyValue,
        "video": video,
      };
}
