import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class HomeCarrucel {
  final String nid;
  final String image;
  final String title;
  final String video;

  HomeCarrucel({
    Key key,
    @required this.nid,
    this.image,
    this.title,
    this.video,
  });

  factory HomeCarrucel.fromJson(Map<String, dynamic> json) {
    return HomeCarrucel(
      nid: json['status']['carrucel'][0]['nid'].toString(),
      image: json['status']['carrucel'][0]['image'],
      title: json['status']['carrucel'][0]['title'],
      video: json['status']['carrucel'][0]['video'],
    );
  }

  @override
  String toString() =>
      'Carrucel { ind: $nid, image: $image, title: $title,  video:$video }';
}
