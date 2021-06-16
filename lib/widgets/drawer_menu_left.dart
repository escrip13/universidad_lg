import 'package:flutter/material.dart';
import 'package:universidad_lg/Ayuda/pages/ayuda_page.dart';
import 'package:universidad_lg/Entrenamiento/pages/entrenamiento_page.dart';
import 'package:universidad_lg/Evaluaciones/pages/evaluacion_page.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Streaming/pages/streaming_page.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/constants.dart';

enum DrawerSections { home, profile, settings, about, logout }

class DrawerMenuLeft extends StatelessWidget {
  final User user;
  final String currenPage;
  const DrawerMenuLeft({
    Key key,
    @required this.user,
    this.currenPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: user,
                                )));
                  },
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
              leading: Icon(Icons.school),
              title: Text('Entrenamiento'),
              onTap: () {
                if (currenPage != 'entrenamiento') {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EntrenamientoPage(user: user);
                  }));
                  // Navigator.pop(context);
                }
                return null;
              }),
          ListTile(
            leading: Icon(Icons.history_edu),
            title: Text('Evaluación'),
            onTap: () {
              if (currenPage != 'evaluaciones') {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EvaluacionPage(user: user);
                }));
                // Navigator.pop(context);
              }
              return null;
            },
          ),
          ListTile(
            leading: Icon(Icons.collections_bookmark),
            title: Text('Biblioteca'),
          ),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('Club'),
            onTap: () {},
          ),
          ListTile(
              leading: Icon(Icons.cast_for_education),
              title: Text('Streamings'),
              onTap: () {
                if (currenPage != 'streaming') {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StreamingPage(user: user);
                  }));
                  // Navigator.pop(context);
                }
                return null;
              }),
          ListTile(
              leading: Icon(Icons.help),
              title: Text('Ayuda'),
              onTap: () {
                if (currenPage != 'ayuda') {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AyudaPage(user: user);
                  }));

                  // Navigator.pop(context);
                }
                return null;
              }),
        ],
      ),
    );
  }
}
