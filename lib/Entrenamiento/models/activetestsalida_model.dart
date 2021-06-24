// To parse this JSON data, do
//
//     final activeTestSalida = activeTestSalidaFromJson(jsonString);

import 'dart:convert';

ActiveTestSalida activeTestSalidaFromJson(String str) =>
    ActiveTestSalida.fromJson(json.decode(str));

String activeTestSalidaToJson(ActiveTestSalida data) =>
    json.encode(data.toJson());

class ActiveTestSalida {
  ActiveTestSalida({
    this.status,
  });

  Status status;

  factory ActiveTestSalida.fromJson(Map<String, dynamic> json) =>
      ActiveTestSalida(
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
  });

  String type;
  int code;
  String message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
      };
}
