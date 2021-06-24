// To parse this JSON data, do
//
//     final singleNoticia = singleNoticiaFromJson(jsonString);

import 'dart:convert';

SingleNoticia singleNoticiaFromJson(String str) =>
    SingleNoticia.fromJson(json.decode(str));

String singleNoticiaToJson(SingleNoticia data) => json.encode(data.toJson());

class SingleNoticia {
  SingleNoticia({
    this.status,
  });

  Status status;

  factory SingleNoticia.fromJson(Map<String, dynamic> json) => SingleNoticia(
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
    this.nid,
    this.title,
    this.uri,
    this.created,
    this.body,
  });

  String nid;
  String title;
  String uri;
  String created;
  String body;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nid: json["nid"],
        title: json["title"],
        uri: json["uri"],
        created: json["created"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "uri": uri,
        "created": created,
        "body": body,
      };
}
