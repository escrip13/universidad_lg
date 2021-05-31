// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Entrenamiento welcomeFromJson(String str) =>
    Entrenamiento.fromJson(json.decode(str));

String welcomeToJson(Entrenamiento data) => json.encode(data.toJson());

class Entrenamiento {
  Entrenamiento({
    this.status,
  });

  Status status;

  factory Entrenamiento.fromJson(Map<String, dynamic> json) => Entrenamiento(
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
    this.cursos,
    this.filtros,
  });

  String type;
  int code;
  String message;
  Cursos cursos;
  List<Filtro> filtros;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        cursos: Cursos.fromJson(json["cursos"]),
        filtros:
            List<Filtro>.from(json["filtros"].map((x) => Filtro.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "cursos": cursos.toJson(),
        "filtros": List<dynamic>.from(filtros.map((x) => x.toJson())),
      };
}

class Cursos {
  Cursos({
    this.avanzado,
    this.intermedio,
    this.basico,
  });

  Map<String, TipoCurso> avanzado;
  Map<String, TipoCurso> intermedio;
  Map<String, TipoCurso> basico;

  factory Cursos.fromJson(Map<String, dynamic> json) => Cursos(
        avanzado: Map.from(json["avanzado"]).map(
            (k, v) => MapEntry<String, TipoCurso>(k, TipoCurso.fromJson(v))),
        intermedio: Map.from(json["intermedio"]).map(
            (k, v) => MapEntry<String, TipoCurso>(k, TipoCurso.fromJson(v))),
        basico: Map.from(json["basico"]).map(
            (k, v) => MapEntry<String, TipoCurso>(k, TipoCurso.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "avanzado": Map.from(avanzado)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "intermedio": Map.from(intermedio)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "basico": Map.from(basico)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class TipoCurso {
  TipoCurso({
    this.nid,
    this.title,
    this.tipo,
    this.imagen,
    this.portada,
    this.porcentaje,
    this.categoria,
    this.body,
  });

  String nid;
  String title;
  String tipo;
  String imagen;
  String portada;
  int porcentaje;
  String categoria;
  String body;

  factory TipoCurso.fromJson(Map<String, dynamic> json) => TipoCurso(
        nid: json["nid"],
        title: json["title"],
        tipo: json["tipo"],
        imagen: json["imagen"],
        portada: json["portada"],
        porcentaje: json["porcentaje"],
        categoria: json["categoria"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "tipo": tipo,
        "imagen": imagen,
        "portada": portada,
        "porcentaje": porcentaje,
        "categoria": categoria,
        "body": body,
      };
}

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
