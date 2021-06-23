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

import 'package:universidad_lg/Home/pages/home_page.dart';

import 'evaluacion_page.dart';

Map preguntasList = {};
CountdownTimerController controllerTime;

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
          body: _SingleEvaluacionContent(
            user: widget.user,
            nid: widget.nid,
          )

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
          '¡ENVIAR EVALUACIÓN!',
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
          content: const Text('lorem mas lorem mas lomrem '),
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
                    text: "EVALUACIÓN: ",
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
