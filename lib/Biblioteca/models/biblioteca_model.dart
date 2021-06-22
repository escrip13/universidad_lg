// To parse this JSON data, do
//
//     final biblioteca = bibliotecaFromJson(jsonString);

import 'dart:convert';

Biblioteca bibliotecaFromJson(String str) =>
    Biblioteca.fromJson(json.decode(str));

String bibliotecaToJson(Biblioteca data) => json.encode(data.toJson());

class Biblioteca {
  Biblioteca({
    this.status,
  });

  Status status;

  factory Biblioteca.fromJson(Map<String, dynamic> json) => Biblioteca(
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
    this.filtros,
    this.filtrosCate,
    this.biblioteca,
  });

  List<Filtro> filtros;
  List<FiltrosCate> filtrosCate;
  List<BibliotecaElement> biblioteca;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        filtros:
            List<Filtro>.from(json["filtros"].map((x) => Filtro.fromJson(x))),
        filtrosCate: List<FiltrosCate>.from(
            json["filtros_cate"].map((x) => FiltrosCate.fromJson(x))),
        biblioteca: List<BibliotecaElement>.from(
            json["biblioteca"].map((x) => BibliotecaElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filtros": List<dynamic>.from(filtros.map((x) => x.toJson())),
        "filtros_cate": List<dynamic>.from(filtrosCate.map((x) => x.toJson())),
        "biblioteca": List<dynamic>.from(biblioteca.map((x) => x.toJson())),
      };
}

class BibliotecaElement {
  BibliotecaElement({
    this.nid,
    this.title,
    this.bodyValue,
    this.fieldRecursosTipoValue,
    this.filtro,
    this.cate,
    this.uri,
    this.recurso,
  });

  String nid;
  String title;
  String bodyValue;
  FieldRecursosTipoValue fieldRecursosTipoValue;
  String filtro;
  String cate;
  String uri;
  String recurso;

  factory BibliotecaElement.fromJson(Map<String, dynamic> json) =>
      BibliotecaElement(
        nid: json["nid"],
        title: json["title"],
        bodyValue: json["body_value"],
        fieldRecursosTipoValue:
            fieldRecursosTipoValueValues.map[json["field_recursos_tipo_value"]],
        filtro: json["filtro"],
        cate: json["cate"],
        uri: json["uri"],
        recurso: json["recurso"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "body_value": bodyValue,
        "field_recursos_tipo_value":
            fieldRecursosTipoValueValues.reverse[fieldRecursosTipoValue],
        "filtro": filtro,
        "cate": cate,
        "uri": uri,
        "recurso": recurso,
      };
}

enum FieldRecursosTipoValue { DOCUMENTO, VIDEO }

final fieldRecursosTipoValueValues = EnumValues({
  "Documento": FieldRecursosTipoValue.DOCUMENTO,
  "Video": FieldRecursosTipoValue.VIDEO
});

class Filtro {
  Filtro({
    this.tid,
    this.name,
  });

  String tid;
  String name;

  factory Filtro.fromJson(Map<String, dynamic> json) => Filtro(
        tid: json["tid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "name": name,
      };
}

class FiltrosCate {
  FiltrosCate({
    this.tid,
    this.name,
    this.parent,
  });

  String tid;
  String name;
  String parent;

  factory FiltrosCate.fromJson(Map<String, dynamic> json) => FiltrosCate(
        tid: json["tid"],
        name: json["name"],
        parent: json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "name": name,
        "parent": parent,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
