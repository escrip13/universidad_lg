import 'package:flutter/material.dart';
import 'package:universidad_lg/constants.dart';

class ButtomMain extends StatelessWidget {
  final String text;
  var onpress;

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
        if (onpress != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return onpress;
          }));
        }
      },
    );
  }
}
