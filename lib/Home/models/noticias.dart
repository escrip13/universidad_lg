import 'package:flutter/material.dart';

class HomeNoticias {
  String nid;
  String title;
  String image;
  String lead;

  HomeNoticias({
    Key key,
    @required this.nid,
    this.title,
    this.image,
    this.lead,
  });

  factory HomeNoticias.fromJson(Map<String, dynamic> json) {
    return HomeNoticias(
      nid: json['status']['carrucel']['nid'],
      title: json['status']['carrucel']['title'],
      image: json['status']['carrucel']['image'],
      lead: json['status']['carrucel']['lead'],
    );
  }

  @override
  String toString() =>
      'Noticias { ind: $nid, image: $image, title: $title,  lead:$lead }';
}
