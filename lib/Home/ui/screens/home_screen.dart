import 'package:flutter/material.dart';
import 'package:universidad_lg/Home/bloc/bloc_home.dart';
import 'package:universidad_lg/User/repository/secure_storage.dart';
import 'package:universidad_lg/widgets/background_image.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  HomeBloc homeBloc;

  void onPressetButtom() async {
    await UserSecureStorage.setLoginSession(null);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          BacgroundImage(
            image: 'assets/img/bg1.jpg',
            height: null,
          ),
          Container(
            child: Center(
              child: TextButton(
                onPressed: onPressetButtom,
                child: Text('pasa'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
