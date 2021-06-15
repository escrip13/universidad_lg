import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento_bloc.dart';
import 'package:universidad_lg/Entrenamiento/models/leccion_model.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_bloc.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_state.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';

import '../../constants.dart';

class LeccionPage extends StatefulWidget {
  final User user;
  final String curso;
  final String leccion;
  const LeccionPage({
    Key key,
    @required this.user,
    @required this.curso,
    @required this.leccion,
  }) : super(key: key);

  @override
  _LeccionPageState createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            user: widget.user,
                          )));
            },
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
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page

            return _LeccionContent(
              user: state.user,
              curso: widget.curso,
              leccion: widget.leccion,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}

class _LeccionContent extends StatefulWidget {
  User user;
  String curso;
  String leccion;
  _LeccionContent({this.user, this.curso, this.leccion});
  @override
  __LeccionContentState createState() => __LeccionContentState();
}

class __LeccionContentState extends State<_LeccionContent> {
  Leccion leccion;
  bool load = false;
  EntrenamientoBloc leccionBloc = EntrenamientoBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void loadData() {
    leccionBloc
        .getLeccionContent(
            token: widget.user.token,
            uid: widget.user.userId,
            curso: widget.curso,
            leccion: widget.leccion)
        .then((value) {
      _onLoad();
      leccion = value;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (load) {
      return Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.8),
              child: CachedNetworkImage(
                imageUrl: leccion.status.data.curso.uri,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: mainColor,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${leccion.status.data.curso.titulo}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Html(
                    data: leccion.status.data.curso.bodyValue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    } else {
      return Center(
        child: CircularProgressIndicator(color: mainColor),
      );
    }
  }
}
