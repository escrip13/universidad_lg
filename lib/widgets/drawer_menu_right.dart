import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/models/home_model.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/constants.dart';

class DrawerMenuRight extends StatelessWidget {
  const DrawerMenuRight({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => HomePage(),
                  child: Image(
                    image: AssetImage('assets/img/new_logo.png'),
                    height: 40,
                  ),
                ),
                Text(
                  'user',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Mi perfil'),
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Mis logros'),
          ),
          ListTile(
            leading: Icon(Icons.public),
            title: Text('Ranking'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) {
                authBloc.add(UserLoggedOut());
                return LoginPage();
              }), (route) => false);
            },
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
