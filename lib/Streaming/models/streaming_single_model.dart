// To parse this JSON data, do
//
//     final singleStreaming = singleStreamingFromJson(jsonString);

import 'dart:convert';

SingleStreaming singleStreamingFromJson(String str) =>
    SingleStreaming.fromJson(json.decode(str));

String singleStreamingToJson(SingleStreaming data) =>
    json.encode(data.toJson());

class SingleStreaming {
  SingleStreaming({
    this.status,
  });

  Status status;

  factory SingleStreaming.fromJson(Map<String, dynamic> json) =>
      SingleStreaming(
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
    this.iframe,
  });

  String nid;
  String title;
  String uri;
  String created;
  String body;
  String iframe;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nid: json["nid"],
        title: json["title"],
        uri: json["uri"],
        created: json["created"],
        body: json["body"],
        iframe: json["iframe"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "title": title,
        "uri": uri,
        "created": created,
        "body": body,
        "iframe": iframe,
      };
}
