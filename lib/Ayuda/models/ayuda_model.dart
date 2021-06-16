// To parse this JSON data, do
//
//     final ayuda = ayudaFromJson(jsonString);

import 'dart:convert';

Ayuda ayudaFromJson(String str) => Ayuda.fromJson(json.decode(str));

String ayudaToJson(Ayuda data) => json.encode(data.toJson());

class Ayuda {
  Ayuda({
    this.status,
  });

  Status status;

  factory Ayuda.fromJson(Map<String, dynamic> json) => Ayuda(
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
  List<Datum> data;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.title,
    this.bodyValue,
    this.isExpanded,
  });

  String title;
  String bodyValue;
  bool isExpanded;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        bodyValue: json["body_value"],
        isExpanded: false,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body_value": bodyValue,
      };
}
