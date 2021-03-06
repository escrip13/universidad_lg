import 'package:flutter/material.dart';
import 'package:universidad_lg/Ayuda/pages/ayuda_page.dart';
import 'package:universidad_lg/Biblioteca/pages/biblioteca_page.dart';
import 'package:universidad_lg/Entrenamiento/pages/entrenamiento_page.dart';
import 'package:universidad_lg/Evaluaciones/pages/evaluacion_page.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Noticias/pages/noticias_page.dart';
import 'package:universidad_lg/Streaming/pages/streaming_page.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/constants.dart';

class DrawerMenuLeft extends StatelessWidget {
  final User user;
  final String currenPage;
  final bool isHome;

  const DrawerMenuLeft({
    Key key,
    @required this.user,
    this.currenPage,
    this.isHome = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: mainColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.school),
              title: Text('Entrenamiento'),
              onTap: () {
                if (currenPage != 'entrenamiento') {
                  Navigator.of(context).pop();
                  if (isHome) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EntrenamientoPage(user: user);
                    }));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return EntrenamientoPage(user: user);
                    }));
                  }
                }
                return null;
              }),
          ListTile(
            leading: Icon(Icons.history_edu),
            title: Text('Evaluaci??n'),
            onTap: () {
              if (currenPage != 'evaluaciones') {
                Navigator.of(context).pop();
                if (isHome) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EvaluacionPage(user: user);
                  }));
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return EvaluacionPage(user: user);
                  }));
                }
              }
              return null;
            },
          ),
          ListTile(
              leading: Icon(Icons.collections_bookmark),
              title: Text('Biblioteca'),
              onTap: () {
                if (currenPage != 'biblioteca') {
                  Navigator.of(context).pop();
                  if (isHome) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BibliotecaPage(user: user);
                    }));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return BibliotecaPage(user: user);
                    }));
                  }
                }
                return null;
              }),
          ListTile(
              leading: Icon(Icons.local_activity),
              title: Text('Noticias'),
              onTap: () {
                if (currenPage != 'noticias') {
                  Navigator.of(context).pop();
                  if (isHome) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return NoticiasPage(user: user);
                    }));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return NoticiasPage(user: user);
                    }));
                  }
                }
                return null;
              }),
          // ListTile(
          //     leading: Icon(Icons.cast_for_education),
          //     title: Text('Streamings'),
          //     onTap: () {
          //       if (currenPage != 'streaming') {
          //         Navigator.of(context).pop();
          //         if (isHome) {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) {
          //             return StreamingPage(user: user);
          //           }));
          //         } else {
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) {
          //             return StreamingPage(user: user);
          //           }));
          //         }
          //       }
          //       return null;
          //     }),
          ListTile(
              leading: Icon(Icons.help),
              title: Text('Ayuda'),
              onTap: () {
                if (currenPage != 'ayuda') {
                  Navigator.of(context).pop();
                  if (isHome) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AyudaPage(user: user);
                    }));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return AyudaPage(user: user);
                    }));
                  }
                }
                return null;
              }),
        ],
      ),
    );
  }
}
