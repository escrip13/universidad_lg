import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:universidad_lg/Evaluaciones/models/send_evaluacion.dart';
import 'package:universidad_lg/Evaluaciones/pages/resultado_page.dart';
import '../../constants.dart';

import 'package:universidad_lg/Evaluaciones/models/single_evaluacion_model.dart';
import 'package:universidad_lg/User/models/models.dart';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';
import 'package:flutter_countdown_timer/index.dart';

import 'package:universidad_lg/Evaluaciones/blocs/evaluacion_bloc.dart';

import 'package:rainbow_color/rainbow_color.dart';

import 'evaluacion_page.dart';

Map preguntasList = {};
CountdownTimerController controllerTime;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SingleEvaluacionPage extends StatefulWidget {
  final User user;
  final String nid;
  const SingleEvaluacionPage({
    Key key,
    @required this.user,
    @required this.nid,
  }) : super(key: key);

  @override
  _SingleEvaluacionPageState createState() => _SingleEvaluacionPageState();
}

class _SingleEvaluacionPageState extends State<SingleEvaluacionPage> {
  EvaluacionBloc evalacionBloc = EvaluacionBloc();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
          key: _scaffoldKey,
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
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: _SingleEvaluacionContent(
            user: widget.user,
            nid: widget.nid,
          )),
    );
  }

  Future<bool> _onBackPressed() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '??DESEA REGRESAR!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'Se enviar?? la informaci??n provista hasta el momento',
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
                  evalacionBloc
                      .sendEvaluacion(
                    data: preguntasList,
                    uid: widget.user.userId,
                    token: widget.user.token,
                    nid: widget.nid,
                  )
                      .then((value) {
                    SendEvaluacion respuesta = value;

                    _result(
                        res: respuesta.status.evaluacionRest,
                        user: widget.user,
                        context: context,
                        id: widget.nid);
                  });
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
  EvaluacionBloc evalacionBloc = EvaluacionBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
        preguntasList = {};
      });
    }
  }

  void loadData() {
    evalacionBloc
        .getSingleEvaluaionesContent(
            token: widget.user.token, uid: widget.user.userId, nid: widget.nid)
        .then((value) {
      _onLoad();
      evaluacionInfo = value;
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
        child: _ContentSingleEvaluacion(
          evaluacionInfo: evaluacionInfo,
          time: int.parse(
            evaluacionInfo.status.tiempo,
          ),
          nid: widget.nid,
          user: widget.user,
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

class _ContentSingleEvaluacion extends StatefulWidget {
  final SingleEvaluacion evaluacionInfo;
  final int time;
  final User user;
  final String nid;

  const _ContentSingleEvaluacion(
      {Key key, this.evaluacionInfo, this.time, this.user, this.nid})
      : super(key: key);

  @override
  __ContentSingleEvaluacionState createState() =>
      __ContentSingleEvaluacionState();
}

class __ContentSingleEvaluacionState extends State<_ContentSingleEvaluacion>
    with TickerProviderStateMixin {
  EvaluacionBloc evalacionBloc = EvaluacionBloc();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<CoolStep> steps = [];
  String selectedRole = '';
  bool _autoValidate = false;
  SendEvaluacion respuesta;
  Color barra = Color(0xFF009846);

  AnimationController controllerAnimation;
  Animation<double> _anim;
  int endTime = 0;

  @override
  void initState() {
    super.initState();
    //crear los steps/////
    listSteps();

    //  inicion de contador
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (widget.time * 60);
    controllerTime =
        CountdownTimerController(endTime: endTime, onEnd: _onFinishTime);

    /// animacion del loader
    controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.time),
    )..addListener(() {
        setState(() {
          // col
        });
      });

    controllerAnimation.repeat(max: 1);
    controllerAnimation.forward();
    _anim = bgValue.animate(controllerAnimation);
  }

  Animatable<double> bgValue = Tween<double>(begin: 0.0, end: 10.0);

  Rainbow rb = Rainbow(rangeStart: 0.0, rangeEnd: 10.0, spectrum: [
    Colors.green,
    Colors.yellow,
    mainColor,
  ]);

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
                  backgroundColor: rb[_anim.value],
                  minHeight: 30.0,
                ),
                CountdownTimer(
                  controller: controllerTime,
                  onEnd: _onFinishTime,
                  endTime: endTime,
                  widgetBuilder: (_, CurrentRemainingTime time) {
                    // print((widget.time / 1.2));
                    // print(time.min);

                    // if (time.min <= 8) {
                    //   setState(() {
                    //     barra = Color(0xFFFFE900);
                    //   });
                    // }

                    if (time == null) {
                      return Text(
                        'Tiempo finalizado',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '${time.min == null ? 0 : time.min} : ${time.sec}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
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

  void listSteps() {
    int cont = 1;
    for (var item in widget.evaluacionInfo.status.preguntas) {
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
            ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
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
  }

  ///////////////  finalizavion de los steps //////////

  _onFinish() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '??ENVIAR EVALUACI??N!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'Se enviar?? tu evaluaci??n',
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
                  evalacionBloc
                      .sendEvaluacion(
                    data: preguntasList,
                    uid: widget.user.userId,
                    token: widget.user.token,
                    nid: widget.nid,
                  )
                      .then((value) {
                    respuesta = value;

                    _result(
                        res: respuesta.status.evaluacionRest,
                        user: widget.user,
                        context: context,
                        id: widget.nid);
                  });
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
          content: const Text(
              'Te has tomado m??s tiempo de lo previsto, El progreso realizado ser?? enviado.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                evalacionBloc
                    .sendEvaluacion(
                  data: preguntasList,
                  uid: widget.user.userId,
                  token: widget.user.token,
                  nid: widget.nid,
                )
                    .then((value) {
                  respuesta = value;

                  _result(
                      res: respuesta.status.evaluacionRest,
                      user: widget.user,
                      context: context,
                      id: widget.nid);
                });
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

_result({EvaluacionRest res, User user, context, String id}) {
  // destroy del contador
  controllerTime.disposeTimer();
  String title = res.titulo;
  int puntaje = res.puntaje;
  String copa = res.copa;

  showDialog<String>(
    context: context,
    barrierDismissible: false,
    // para no cerrar outclick de la alerta
    builder: (BuildContext context) => WillPopScope(
      // will para evitar el retroceso
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Text(
          'RESULTADO',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: Container(
          height: 200.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                    text: "EVALUACI??N: ",
                    style: TextStyle(color: mainColor),
                    children: [
                      TextSpan(
                          text: title, style: TextStyle(color: Colors.black))
                    ]),
              ),
              SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                    text: "PUNTAJE: ",
                    style: TextStyle(color: mainColor),
                    children: [
                      TextSpan(
                          text: '$puntaje%',
                          style: TextStyle(color: Colors.black))
                    ]),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Icon(Icons.emoji_events, color: mainColor),
                  Text(copa)
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultadoPage(
                                user: user,
                                evaluacion: id,
                              )));
                },
                child: const Text(
                  'VER RESPUESTAS',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  // debe haber un forma de retocedder el nav hasta un  punto
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => EvaluacionPage(
                                user: user,
                              )));
                },
                child: const Text(
                  'CONTINUAR',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
