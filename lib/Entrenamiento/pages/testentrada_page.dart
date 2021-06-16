import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:universidad_lg/Entrenamiento/pages/entrenamiento_page.dart';
import '../../constants.dart';

import 'package:universidad_lg/Entrenamiento/models/testentrada_model.dart';
import 'package:universidad_lg/User/models/models.dart';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';
import 'package:flutter_countdown_timer/index.dart';

import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento_bloc.dart';

import 'package:universidad_lg/Home/pages/home_page.dart';

import 'cursopreview_page.dart';

Map preguntasList = {};
CountdownTimerController controllerTime;

class TestEntradaPage extends StatefulWidget {
  final User user;
  final String curso;
  final String leccion;
  const TestEntradaPage({
    Key key,
    @required this.user,
    @required this.curso,
    @required this.leccion,
  }) : super(key: key);

  @override
  _TestEntradaPageState createState() => _TestEntradaPageState();
}

class _TestEntradaPageState extends State<TestEntradaPage> {
  EntrenamientoBloc entrenamientoBloc = EntrenamientoBloc();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
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
          // drawer: DrawerMenuLeft(
          //   user: widget.user,
          //   currenPage: 'evaluaciones',
          // ),
          // endDrawer: DrawerMenuRight(),
          body: _TestEntradaContent(
              user: widget.user, curso: widget.curso, leccion: widget.leccion)

          // otherwise show login page

          ),
    );
  }

  Future<bool> _onBackPressed() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '¡DESEA REGRESAR!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'Se enviará la información provista hasta el momento',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // evalacionBloc
                  //     .sendEvaluacion(
                  //   data: preguntasList,
                  //   uid: widget.user.userId,
                  //   token: widget.user.token,
                  //   nid: widget.nid,
                  // )
                  //     .then((value) {
                  //   SendEvaluacion respuesta = value;

                  //   _result(
                  //       res: respuesta.status.evaluacionRest,
                  //       user: widget.user,
                  //       context: context,
                  //       id: widget.nid);
                  // });
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
    return false;
  }
}

class _TestEntradaContent extends StatefulWidget {
  User user;
  String curso;
  String leccion;
  _TestEntradaContent({this.user, this.curso, this.leccion});
  @override
  __TestEntradaContentState createState() => __TestEntradaContentState();
}

class __TestEntradaContentState extends State<_TestEntradaContent> {
  TestEntrada testEntradaInfo;
  bool load = false;
  EntrenamientoBloc testEntradaBloc = EntrenamientoBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
        preguntasList = {};
      });
    }
  }

  void loadData() {
    testEntradaBloc
        .getTestEntradaContent(
            token: widget.user.token,
            uid: widget.user.userId,
            curso: widget.curso,
            leccion: widget.leccion)
        .then((value) {
      _onLoad();
      testEntradaInfo = value;
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
        // padding: EdgeInsets.all(0),
        child: _ContentTestEntrada(
          testEntradaInfo: testEntradaInfo,
          time: int.parse(
            testEntradaInfo.status.tiempo,
          ),
          user: widget.user,
          curso: widget.curso,
          leccion: widget.leccion,
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

class _ContentTestEntrada extends StatefulWidget {
  final TestEntrada testEntradaInfo;
  int time;
  User user;
  String curso;
  String leccion;

  _ContentTestEntrada(
      {this.testEntradaInfo, this.time, this.user, this.curso, this.leccion});

  @override
  __ContentTestEntradaState createState() => __ContentTestEntradaState();
}

class __ContentTestEntradaState extends State<_ContentTestEntrada>
    with TickerProviderStateMixin {
  // EvaluacionBloc evalacionBloc = EvaluacionBloc();
  EntrenamientoBloc testEntradaBloc = EntrenamientoBloc();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<CoolStep> steps = [];
  String selectedRole = '';
  bool _autoValidate = false;
  // SendEvaluacion respuesta;

  AnimationController controllerAnimation;
  int endTime = 0;

  @override
  void initState() {
    super.initState();
    //crear los steps/////
    listSteps(context);

    //  inicion de contador
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (widget.time * 60);
    controllerTime =
        CountdownTimerController(endTime: endTime, onEnd: _onFinishTime);

    /// animacion del loader
    controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.time),
    )..addListener(() {
        setState(() {});
      });
    controllerAnimation.repeat(max: 1);
    controllerAnimation.forward();
  }

  @override
  void dispose() {
    // detroy de la animacion
    controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _key,
        autovalidateMode:
            _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: Column(children: [
          Expanded(
            child: CoolStepper(
              showErrorSnackbar: false,
              onCompleted: () {
                _onFinish();
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
                subtitleTextStyle:
                    TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: controllerAnimation.value,
                  color: mainColor,
                  backgroundColor: secondColor,
                  minHeight: 25.0,
                ),
                CountdownTimer(
                  controller: controllerTime,
                  onEnd: _onFinishTime,
                  endTime: endTime,
                  widgetBuilder: (_, CurrentRemainingTime time) {
                    if (time == null) {
                      return Text(
                        'Tiempo finalizado',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return Text(
                      '${time.min == null ? 0 : time.min} : ${time.sec}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  ////////////////////  llenar los steps/////////////////

  List listSteps(context) {
    int cont = 1;
    for (var item in widget.testEntradaInfo.status.preguntas) {
      // List<Respuesta> repustas = item.respuestas;
      List<Respuesta> respuesta = item.respuestas;

      final List<Map> data = [];

      for (var rs in respuesta) {
        data.add({'value': rs.delta, 'display': rs.texto});
      }
      preguntasList[item.id] = '0';
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

          /// guarda el formulatio despues de cada step para llenar el map  ///
          _key.currentState.save();
          return null;
        },
      ));
      cont++;
    }
    return steps;
  }

  ///////////////  finalizavion de los steps //////////

  _onFinish() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '¡ENVIAR TEST ENTRADA!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'lorem mas lorem mas lorem',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'CANCELAR',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // evalacionBloc
                  //     .sendEvaluacion(
                  //   data: preguntasList,
                  //   uid: widget.user.userId,
                  //   token: widget.user.token,
                  //   nid: widget.nid,
                  // )
                  //     .then((value) {
                  //   respuesta = value;

                  //   _result(
                  //       res: respuesta.status.evaluacionRest,
                  //       user: widget.user,
                  //       context: context,
                  //       id: widget.nid);
                  // });

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => EntrenamientoPage(
                                user: widget.user,
                              )));
                },
                child: const Text(
                  'ENVIAR',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

    // print(preguntasList);
  }

  ///  finalizacion del tiempo ////
  _onFinishTime() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text(
            '!TIEMPO FINALIZADO!',
            textAlign: TextAlign.center,
            style: TextStyle(color: mainColor),
          ),
          content: const Text('lorem mas lorem mas lomrem '),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // evalacionBloc
                //     .sendEvaluacion(
                //   data: preguntasList,
                //   uid: widget.user.userId,
                //   token: widget.user.token,
                //   nid: widget.nid,
                // )
                //     .then((value) {
                //   respuesta = value;

                //   _result(
                //       res: respuesta.status.evaluacionRest,
                //       user: widget.user,
                //       context: context,
                //       id: widget.nid);
                // });
              },
              child: const Text(
                'ENVIAR',
                style: TextStyle(color: mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// resivir el resultado ///
}
