import 'package:flutter/material.dart';

class BacgroundImage extends StatelessWidget {
  double height = 0;
  String image = '';

  BacgroundImage({this.height, this.image});
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;

    if (height == null) {
      height = screenHeight;
    }

    return Container(
      height: height,
      width: screenWidht,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      )),
    );
  }
}
