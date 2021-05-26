import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

import 'package:universidad_lg/Home/blocs/home/home_bloc.dart';
import 'package:universidad_lg/Home/models/models.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../constants.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Container(
          child: _HomeContent(
            user: user,
          ),
        ));
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

  void _incrementCounter() {
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    homeBloc
        .getHomeContent(token: widget.user.token, uid: widget.user.userId)
        .then((value) {
      _incrementCounter();
      homeInfo = value;
    });

    if (load) {
      return Container(
        // padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _CarrucelHome(homeInfo.status.carrucel),
              _CalendarioHome(),
              _NoticiasHome(homeInfo.status.noticias),
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
                  child:
                      Image.network(i.imagen, fit: BoxFit.cover, width: 1000),
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

class _CalendarioHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: mainColor),
      child: TextButton(
        child: Text(
          'CALENDARIO',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => print('deberia abrir el calendario'),
      ),
    );
  }
}

// ignore: must_be_immutable
class _NoticiasHome extends StatefulWidget {
  List<Noticias> dataNoticias;
  _NoticiasHome(this.dataNoticias);

  @override
  __NoticiasHome createState() => __NoticiasHome();
}

class __NoticiasHome extends State<_NoticiasHome> {
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
                  height: 330,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: widget.dataNoticias.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Image.network(
                          i.imagen,
                          width: 1000,
                        ),

                        Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                          ),
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            i.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          child: Text(
                            i.lead,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        )
                        // Text(i.title),
                      ],

                      // Text(i.title),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.dataNoticias.map((url) {
                int index = widget.dataNoticias.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? mainColor : Colors.black26,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
