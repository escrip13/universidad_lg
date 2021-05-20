import 'package:flutter/material.dart';

class User {
  final String correo;
  final String password;

  User({
    Key key,
    @required this.correo,
    @required this.password,
  });
}
