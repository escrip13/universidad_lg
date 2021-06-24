import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:universidad_lg/Home/blocs/home/home_bloc.dart';
import 'package:universidad_lg/Home/models/models.dart';
import 'package:universidad_lg/Noticias/pages/noticias_single_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_bloc.dart';
import 'package:universidad_lg/User/blocs/blocs.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:universidad_lg/widgets/background_image.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

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
            onTap: () => HomePage(),
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
      ),
      endDrawer: DrawerMenuRight(
        user: user,
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
              _ConoceMas(),
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
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
              // height: 211.5,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: widget.dataCarrucel.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    // padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: i.imagen,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                    // Image.network(i.imagen, fit: BoxFit.cover, width: 1000),
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
              'CONOCE MÁS DE LO \nQUE TENEMOS PARA TI',
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
                        print('aa');
                      },
                      child: Text('BIBLIOTECA'),
                    ),
                  ],
                ),
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     BacgroundImage(
                //       image: 'assets/img/club.png',
                //       height: 240.0,
                //     ),
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //           padding: EdgeInsets.symmetric(horizontal: 30.0),
                //           primary: Colors.transparent,
                //           shadowColor: Colors.transparent,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.zero,
                //           ),
                //           side: BorderSide(width: 1.0, color: Colors.white)),
                //       onPressed: () {
                //         authBloc.add(UserLoggedOut());
                //       },
                //       child: Text('CLUB LG'),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
