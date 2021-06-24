// To parse this JSON data, do
//
//     final sendTestEntrada = sendTestEntradaFromJson(jsonString);

import 'dart:convert';

SendTestEntrada sendTestEntradaFromJson(String str) =>
    SendTestEntrada.fromJson(json.decode(str));

String sendTestEntradaToJson(SendTestEntrada data) =>
    json.encode(data.toJson());

class SendTestEntrada {
  SendTestEntrada({
    this.status,
  });

  Status status;

  factory SendTestEntrada.fromJson(Map<String, dynamic> json) =>
      SendTestEntrada(
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
    this.dataTest,
  });

  String type;
  int code;
  String message;
  DataTest dataTest;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        dataTest: DataTest.fromJson(json["dataTest"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "dataTest": dataTest.toJson(),
      };
}

class DataTest {
  DataTest({
    this.copa,
    this.puntaje,
    this.titulo,
    this.nombre,
  });

  String copa;
  int puntaje;
  String titulo;
  String nombre;

  factory DataTest.fromJson(Map<String, dynamic> json) => DataTest(
        copa: json["copa"],
        puntaje: json["puntaje"],
        titulo: json["titulo"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "copa": copa,
        "puntaje": puntaje,
        "titulo": titulo,
        "nombre": nombre,
      };
}
