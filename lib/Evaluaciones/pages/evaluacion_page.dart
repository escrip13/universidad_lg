import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Evaluaciones/blocs/evaluacion.dart';
import 'package:universidad_lg/Evaluaciones/models/evaluacion_model.dart';
import 'package:universidad_lg/Evaluaciones/pages/single_evaluacion_page.dart';

import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/models.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants.dart';

class EvaluacionPage extends StatelessWidget {
  final User user;
  const EvaluacionPage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
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
      backgroundColor: Colors.white,
      drawer: DrawerMenuLeft(
        user: user,
        currenPage: 'evaluaciones',
      ),
      endDrawer: DrawerMenuRight(),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page

            return _EvaluacionContent(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}

class _EvaluacionContent extends StatefulWidget {
  final User user;
  const _EvaluacionContent({Key key, this.user}) : super(key: key);
  @override
  __EvaluacionContent createState() => __EvaluacionContent();
}

class __EvaluacionContent extends State<_EvaluacionContent> {
  Evaluacion evaluacionInfo;
  bool load = false;
  EvaluacionBloc evalacioonBloc = EvaluacionBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void loadData() {
    evalacioonBloc
        .getEvaluaionesContent(
            token: widget.user.token, uid: widget.user.userId)
        .then((value) {
      _onLoad();
      evaluacionInfo = value;
    });
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
            _ContentEvaluacion(
                evaluacionInfo: evaluacionInfo.status.evaluaciones,
                user: widget.user),
          ],
        ),
      ));
    }

    loadData();
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

class _ContentEvaluacion extends StatefulWidget {
  List<EvaluacionItem> evaluacionInfo;
  User user;

  _ContentEvaluacion({this.evaluacionInfo, this.user});

  @override
  __ContentEvaluacionState createState() => __ContentEvaluacionState();
}

class __ContentEvaluacionState extends State<_ContentEvaluacion> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        for (var item in widget.evaluacionInfo)
          _ItemEvaluacion(
            evaluacion: item,
            user: widget.user,
          )
      ],
    );
  }
}

class _ItemEvaluacion extends StatelessWidget {
  EvaluacionItem evaluacion;
  User user;

  _ItemEvaluacion({this.evaluacion, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: evaluacion.portada,
            placeholder: (context, url) => CircularProgressIndicator(
              color: mainColor,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' ${evaluacion.porcentaje}% Desarrollado',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: mainColor),
                  ),
                ),
                Text(
                  evaluacion.title,
                  style: TextStyle(fontSize: 18.0),
                ),
                if (evaluacion.porcentaje == 0)
                  ButtomMain(
                      text: 'VER EVALUACIÓN',
                      onpress: SingleEvaluacionPage(
                        user: user,
                        nid: evaluacion.nid,
                      ))
                else
                  ButtomMain(text: 'REALIZADA', onpress: null)
              ],
            ),
          )
        ],
      ),
    );
  }
}
