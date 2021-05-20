import 'package:flutter/material.dart';
import 'package:universidad_lg/Home/ui/screens/home_screen.dart';
import 'package:universidad_lg/User/bloc/bloc_user.dart';
import 'package:universidad_lg/User/repository/secure_storage.dart';
import 'package:universidad_lg/User/ui/widgets/form_login.dart';
import 'package:universidad_lg/widgets/background_image.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  UserBloc userBloc;
  String session;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<String> init() async {
    return Future.value(await UserSecureStorage.getLoginSession()); //
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession() {
    return FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return singInLg();
          }
        });
  }

  Widget singInLg() {
    final logo = Container(
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          // border: Border
          ),
      child: Image(
        image: AssetImage('assets/img/logolg.png'),
      ),
    );

    final titulo = Container(
      margin: EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Text(
        'Universidad LG',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
        ),
      ),
    );

    final contLogin = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(
              right: 30.0,
              left: 30.0,
            ),
            child: Column(
              children: [
                logo,
                titulo,
                FormLogin(
                  userBloc: userBloc,
                ),
              ],
            ))
      ],
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          BacgroundImage(
            image: 'assets/img/bg1.jpg',
            height: null,
          ),
          contLogin
        ],
      ),
    );
  }
}
