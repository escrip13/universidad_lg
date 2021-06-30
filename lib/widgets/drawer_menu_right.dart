import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Ranking/pages/ranking_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/User/pages/logros_page.dart';
import 'package:universidad_lg/User/pages/perfil_page.dart';
import 'package:universidad_lg/constants.dart';

class DrawerMenuRight extends StatelessWidget {
  final User user;
  final String currenPage;
  final bool isHome;
  const DrawerMenuRight({
    Key key,
    this.user,
    this.currenPage,
    this.isHome = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

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
                  onTap: () {
                    if (!isHome) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (_) {
                        return HomePage(
                          user: user,
                        );
                      }), (route) => false);
                    }
                  },
                  child: Image(
                    image: AssetImage('assets/img/new_logo.png'),
                    height: 40,
                  ),
                ),
                Text(
                  user.name,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Mi perfil'),
            onTap: () {
              if (currenPage != 'perfil') {
                Navigator.of(context).pop();
                if (isHome) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PerfilPage(
                      user: user,
                    );
                  }));
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return PerfilPage(
                      user: user,
                    );
                  }));
                }
              }
              return null;
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Mis logros'),
            onTap: () {
              if (currenPage != 'logros') {
                Navigator.of(context).pop();
                if (isHome) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PageLogros(
                      user: user,
                    );
                  }));
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return PageLogros(
                      user: user,
                    );
                  }));
                }
              }
              return null;
            },
          ),
          ListTile(
            leading: Icon(Icons.public),
            title: Text('Ranking'),
            onTap: () {
              if (currenPage != 'ranking') {
                Navigator.of(context).pop();
                if (isHome) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PageRanking(
                      user: user,
                    );
                  }));
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return PageRanking(
                      user: user,
                    );
                  }));
                }
              }
              return null;
            },
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
