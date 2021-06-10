// To parse this JSON data, do
//
//     final streaming = streamingFromJson(jsonString);

import 'dart:convert';

Streaming streamingFromJson(String str) => Streaming.fromJson(json.decode(str));

String streamingToJson(Streaming data) => json.encode(data.toJson());

class Streaming {
  Streaming({
    this.status,
  });

  Status status;

  factory Streaming.fromJson(Map<String, dynamic> json) => Streaming(
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
    this.nid,
    this.title,
    this.created,
    this.uri,
    this.bodyValue,
  });

  String nid;
  String title;
  String created;
  String uri;
  String bodyValue;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        nid: json["nid"],
        title: json["title"],
        created: json["created"],
        uri: json["uri"],
        bodyValue: json["body_value"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "created": created,
        "uri": uri,
        "body_value": bodyValue,
      };
}
