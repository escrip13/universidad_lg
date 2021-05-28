// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Entrenamiento welcomeFromJson(String str) =>
    Entrenamiento.fromJson(json.decode(str));

String welcomeToJson(Entrenamiento data) => json.encode(data.toJson());

class Entrenamiento {
  Entrenamiento({
    this.cursosAgrupados,
    this.cursosTerminado,
    this.filtros,
  });

  CursosAgrupados cursosAgrupados;
  dynamic cursosTerminado;
  List<Filtro> filtros;

  factory Entrenamiento.fromJson(Map<String, dynamic> json) => Entrenamiento(
        cursosAgrupados: CursosAgrupados.fromJson(json["cursosAgrupados"]),
        cursosTerminado: json["cursosTerminado"],
        filtros:
            List<Filtro>.from(json["filtros"].map((x) => Filtro.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cursosAgrupados": cursosAgrupados.toJson(),
        "cursosTerminado": cursosTerminado,
        "filtros": List<dynamic>.from(filtros.map((x) => x.toJson())),
      };
}

class CursosAgrupados {
  CursosAgrupados({
    this.type,
  });

  Type type;

  factory CursosAgrupados.fromJson(Map<String, dynamic> json) =>
      CursosAgrupados(
        type: Type.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type.toJson(),
      };
}

class Type {
  Type({
    this.avanzado,
    this.intermedio,
    this.basico,
  });

  Map<String, Avanzado> avanzado;
  Map<String, Avanzado> intermedio;
  Map<String, Avanzado> basico;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        avanzado: Map.from(json["avanzado"])
            .map((k, v) => MapEntry<String, Avanzado>(k, Avanzado.fromJson(v))),
        intermedio: Map.from(json["intermedio"])
            .map((k, v) => MapEntry<String, Avanzado>(k, Avanzado.fromJson(v))),
        basico: Map.from(json["basico"])
            .map((k, v) => MapEntry<String, Avanzado>(k, Avanzado.fromJson(v))),
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

class Avanzado {
  Avanzado({
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

  factory Avanzado.fromJson(Map<String, dynamic> json) => Avanzado(
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
