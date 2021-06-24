// To parse this JSON data, do
//
//     final sendTestSalida = sendTestSalidaFromJson(jsonString);

import 'dart:convert';

SendTestSalida sendTestSalidaFromJson(String str) =>
    SendTestSalida.fromJson(json.decode(str));

String sendTestSalidaToJson(SendTestSalida data) => json.encode(data.toJson());

class SendTestSalida {
  SendTestSalida({
    this.status,
  });

  Status status;

  factory SendTestSalida.fromJson(Map<String, dynamic> json) => SendTestSalida(
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
    this.sustituto,
    this.copa,
    this.puntaje,
    this.titulo,
    this.nombre,
  });

  int sustituto;
  String copa;
  int puntaje;
  String titulo;
  String nombre;

  factory DataTest.fromJson(Map<String, dynamic> json) => DataTest(
        sustituto: json["sustituto"],
        copa: json["copa"],
        puntaje: json["puntaje"],
        titulo: json["titulo"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "sustituto": sustituto,
        "copa": copa,
        "puntaje": puntaje,
        "titulo": titulo,
        "nombre": nombre,
      };
}
