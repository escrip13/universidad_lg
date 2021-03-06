// @dart=2.9
// import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:universidad_lg/Biblioteca/pages/biblioteca_page.dart';
import 'package:universidad_lg/Entrenamiento/pages/cursopreview_page.dart';
import 'package:universidad_lg/Entrenamiento/pages/entrenamiento_page.dart';
import 'package:universidad_lg/Evaluaciones/pages/evaluacion_page.dart';
import 'package:universidad_lg/Home/blocs/home/home_bloc.dart';
import 'package:universidad_lg/Home/models/models.dart';
import 'package:universidad_lg/Noticias/pages/noticias_single_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_bloc.dart';
import 'package:universidad_lg/User/blocs/blocs.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:universidad_lg/widgets/background_image.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
// import 'package:universidad_lg/Home/pages/globals.dart' as globals;
import '../../constants.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(user.token);
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            child: Image(
              image: AssetImage('assets/img/new_logo.png'),
              height: 35,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.person),
            ),
          ),
        ],
      ),
      backgroundColor: mainColor,
      drawer: DrawerMenuLeft(
        user: user,
        isHome: true,
      ),
      endDrawer: DrawerMenuRight(
        user: user,
        isHome: true,
      ),

      body: Builder(
        builder: (context) => Container(
          color: Colors.white,
          child: _HomeContent(
            user: user,
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final User user;
  const _HomeContent({Key key, this.user}) : super(key: key);
  @override
  __HomeContent createState() => __HomeContent();
}

class __HomeContent extends State<_HomeContent> {
  // static final String oneSignalAppId = "a1ea5f8a-4412-4e90-8fd0-8ac42aa31921";
  Home homeInfo;
  bool load = false;
  HomeBloc homeBloc = HomeBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void _loader() {
    homeBloc
        .getHomeContent(token: widget.user.token, uid: widget.user.userId)
        .then((value) {
      _onLoad();
      homeInfo = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loader();
    initPlatformState();
    print('fff');
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    if (load) {
      return Container(
        // padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _CarrucelHome(homeInfo.status.carrucel),
              // _CalendarioHome(),
              _NoticiasHome(homeInfo.status.noticias, widget.user),
              _ConoceMas(user: widget.user),
            ],
          ),
        ),
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId("a1ea5f8a-4412-4e90-8fd0-8ac42aa31921");

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      String tipoRespuesta = result.notification.additionalData['type'];

      if (tipoRespuesta.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          if (tipoRespuesta == 'curso') {
            String id = result.notification.additionalData['nid'].toString();
            return CursoPreviewPage(user: widget.user, nid: id);
          }
          if (tipoRespuesta == 'evaluacion') {
            return EvaluacionPage(user: widget.user);
          }
          if (tipoRespuesta == 'biblioteca') {
            return BibliotecaPage(
              user: widget.user,
            );
          }
          return null;
        }));
      }
    });

    //   OneSignal.shared.init(
    //     oneSignalAppId,
    //   );

    //   OneSignal.shared
    //       .setInFocusDisplayType(OSNotificationDisplayType.notification);

    //   OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    //     var data = openedResult.notification.payload.additionalData;

    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       // print(data);

    //       return null;
    //     }));
    //   });
  }
}

// ignore: must_be_immutable
class _CarrucelHome extends StatefulWidget {
  List<Carrucel> dataCarrucel;
  _CarrucelHome(this.dataCarrucel);

  @override
  __CarrucelHomeState createState() => __CarrucelHomeState();
}

class __CarrucelHomeState extends State<_CarrucelHome> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 200,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: widget.dataCarrucel.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return CachedNetworkImage(
                  alignment: Alignment.topCenter,
                  imageUrl: i.imagen,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.dataCarrucel.map((url) {
            int index = widget.dataCarrucel.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(color: mainColor, width: 1)),
                shape: BoxShape.circle,
                color: _current == index ? mainColor : Colors.white,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _NoticiasHome extends StatefulWidget {
  final User user;
  List<Noticias> dataNoticias;
  _NoticiasHome(this.dataNoticias, this.user);

  @override
  __NoticiasHome createState() => __NoticiasHome();
}

class __NoticiasHome extends State<_NoticiasHome> {
  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'NOTICIAS',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 340,
                viewportFraction: 1.0,
                aspectRatio: 2.0,
              ),
              carouselController: buttonCarouselController,
              items: widget.dataNoticias.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoticiaSinglePage(
                                      user: widget.user,
                                      nid: i.nid,
                                    )));
                      },
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: i.imagen,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: mainColor,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 20,
                            ),
                            child: Text(
                              i.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1,
                              ),
                              maxLines: 3,
                            ),
                          ),
                          Container(
                            child: Text(
                              i.lead,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13),
                            ),
                          )
                          // Text(i.title),
                        ],
                        // Text(i.title),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: () => buttonCarouselController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        Text('ANTERIOR',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: () => buttonCarouselController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        Text('SIGUIENTE',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ))
                      ],
                    )),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _ConoceMas extends StatelessWidget {
  final User user;

  const _ConoceMas({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
            alignment: Alignment.topLeft,
            child: Text(
              'CONOCE M??S DE LO \nQUE TENEMOS PARA TI',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    BacgroundImage(
                      image: 'assets/img/club.png',
                      height: 240.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: BorderSide(width: 1.0, color: Colors.white)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EntrenamientoPage(user: user);
                        }));
                      },
                      child: Text('ENTRENAMIENTO'),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    BacgroundImage(
                      image: 'assets/img/biblioteca.png',
                      height: 240.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: BorderSide(width: 1.0, color: Colors.white)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BibliotecaPage(user: user);
                        }));
                      },
                      child: Text('BIBLIOTECA'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
