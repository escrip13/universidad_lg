import 'package:flutter/material.dart';
import 'package:universidad_lg/Entrenamiento/models/entrenamiento_model.dart';
import 'package:universidad_lg/constants.dart';

class ButtomMain extends StatelessWidget {
  String text;
  TipoCurso onpress;

  ButtomMain({this.text, this.onpress});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        primary: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: Text(text),
      onPressed: () {
        print('ddd');
      },
    );
  }
}
