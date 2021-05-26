import 'dart:convert';

Home welcomeFromJson(String str) => Home.fromJson(json.decode(str));

String welcomeToJson(Home data) => json.encode(data.toJson());

class Home {
  Home({
    this.status,
  });

  Status status;

  factory Home.fromJson(Map<String, dynamic> json) => Home(
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
    this.carrucel,
    this.noticias,
  });

  String type;
  int code;
  String message;
  List<Carrucel> carrucel;
  List<Noticias> noticias;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        code: json["code"],
        message: json["message"],
        carrucel: List<Carrucel>.from(
            json["carrucel"].map((x) => Carrucel.fromJson(x))),
        noticias: List<Noticias>.from(
            json["noticias"].map((x) => Noticias.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "message": message,
        "carrucel": List<dynamic>.from(carrucel.map((x) => x.toJson())),
        "noticias": List<dynamic>.from(noticias.map((x) => x.toJson())),
      };
}

class Carrucel {
  Carrucel({
    this.imagen,
    this.nid,
    this.title,
    this.video,
    this.lead,
  });

  String imagen;
  String nid;
  String title;
  String video;
  String lead;

  factory Carrucel.fromJson(Map<String, dynamic> json) => Carrucel(
        imagen: json["imagen"],
        nid: json["nid"],
        title: json["title"],
        video: json["video"] == null ? null : json["video"],
        lead: json["lead"] == null ? null : json["lead"],
      );

  Map<String, dynamic> toJson() => {
        "imagen": imagen,
        "nid": nid,
        "title": title,
        "video": video == null ? null : video,
        "lead": lead == null ? null : lead,
      };
}

class Noticias {
  Noticias({
    this.imagen,
    this.nid,
    this.title,
    this.lead,
  });

  String imagen;
  String nid;
  String title;
  String video;
  String lead;

  factory Noticias.fromJson(Map<String, dynamic> json) => Noticias(
        imagen: json["imagen"],
        nid: json["nid"],
        title: json["title"],
        lead: json["lead"] == null ? null : json["lead"],
      );

  Map<String, dynamic> toJson() => {
        "imagen": imagen,
        "nid": nid,
        "title": title,
        "lead": lead == null ? null : lead,
      };
}
