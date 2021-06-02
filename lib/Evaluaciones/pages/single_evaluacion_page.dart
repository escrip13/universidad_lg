import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Evaluaciones/blocs/evaluacion_bloc.dart';
import 'package:universidad_lg/Evaluaciones/models/single_evaluacion_model.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/models.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';

import '../../constants.dart';

class SingleEvaluacionPage extends StatelessWidget {
  final User user;
  final String nid;
  const SingleEvaluacionPage({
    Key key,
    @required this.user,
    @required this.nid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

            return _SingleEvaluacionContent(user: state.user, nid: nid);
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}

class _SingleEvaluacionContent extends StatefulWidget {
  User user;
  String nid;
  _SingleEvaluacionContent({this.user, this.nid});
  @override
  __SingleEvaluacionContentState createState() =>
      __SingleEvaluacionContentState();
}

class __SingleEvaluacionContentState extends State<_SingleEvaluacionContent> {
  SingleEvaluacion evaluacionInfo;
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
        .getSingleEvaluaionesContent(
            token: widget.user.token, uid: widget.user.userId, nid: widget.nid)
        .then((value) {
      _onLoad();
      evaluacionInfo = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (load) {
      return Container(
        // padding: EdgeInsets.all(0),
        child: _ContentSingleEvaluacion(
          evaluacionInfo: evaluacionInfo.status,
          time: int.parse(evaluacionInfo.status.tiempo),
        ),
      );
    }

    loadData();

    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

class _ContentSingleEvaluacion extends StatefulWidget {
  final Status evaluacionInfo;
  int time;
  _ContentSingleEvaluacion({this.evaluacionInfo, this.time});

  @override
  __ContentSingleEvaluacionState createState() =>
      __ContentSingleEvaluacionState();
}

class __ContentSingleEvaluacionState extends State<_ContentSingleEvaluacion> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Map preguntasList = {};
  List<CoolStep> steps = [];
  bool cargo = false;
  String selectedRole = '';
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (!cargo) {
        listSteps(context);
        cargo = true;
      }
    });

    // startTimeout();
    // print(totalTime);

    // print(preguntasList);

    return Container(
      child: Form(
        key: _key,
        autovalidateMode:
            _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: Stack(children: [
          CoolStepper(
            showErrorSnackbar: false,
            onCompleted: () {
              _onSave();
            },
            steps: steps,
            config: CoolStepperConfig(
              backText: 'ANTERIOR',
              nextText: 'SIGUIENTE',
              finalText: 'ENVIAR',
              stepText: '',
              iconColor: mainColor,
              ofText: 'DE',
              headerColor: mainColor,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
              subtitleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          Positioned(
            child: Text('sss'),
            top: 30.0,
            right: 30.0,
          )
        ]),
      ),
    );
  }

  List listSteps(context) {
    int cont = 1;
    for (var item in widget.evaluacionInfo.preguntas) {
      // List<Respuesta> repustas = item.respuestas;
      List<Respuesta> respuesta = item.respuestas;

      final List<Map> data = [];

      for (var rs in respuesta) {
        data.add({'value': rs.delta, 'display': rs.texto});
      }

      preguntasList[item.id] = '';

      steps.add(CoolStep(
        title: 'Pregunta $cont',
        subtitle: item.texto,
        content: Container(
          child: Column(
            children: <Widget>[
              RadioButtonFormField(
                toggleable: true,
                padding: EdgeInsets.all(8),
                context: context,
                value: 'value',
                display: 'display',
                data: data,
                activeColor: mainColor,
                autoValidate: true,
                onSaved: (value) {
                  setState(() {
                    preguntasList[item.id] = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'no pasa';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        validation: () {
          setState(() {
            _autoValidate = true;
          });

          if (!_key.currentState.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Marca una casilla para continuar'),
                backgroundColor: mainColor,
              ),
            );

            return 'no-pasa';
          }

          _key.currentState.save();

          return null;
        },
      ));
      cont++;
    }

    return steps;
  }

  _onSave() {
    // _key.currentState.save();
    print(preguntasList);
    print('pasa');

    _key.currentState.save();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('!DESEA ENVIAR!'),
        content: const Text('AlertDialog description'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // print(preguntasList);
  }
}
