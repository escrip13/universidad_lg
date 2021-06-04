import 'package:flutter/material.dart';
import 'package:universidad_lg/Evaluaciones/models/send_evaluacion.dart';
import '../../constants.dart';

import 'package:universidad_lg/Evaluaciones/models/single_evaluacion_model.dart';
import 'package:universidad_lg/User/models/models.dart';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';
import 'package:flutter_countdown_timer/index.dart';

import 'package:universidad_lg/Evaluaciones/blocs/evaluacion_bloc.dart';

import 'package:universidad_lg/Home/pages/home_page.dart';

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
  bool shouldPop = false;

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
          '¡Desea regresar!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'perderas todo el progreso',
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
                  print(preguntasList);
                  controllerTime.disposeTimer();

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
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
  int time;
  User user;
  String nid;

  _ContentSingleEvaluacion(
      {this.evaluacionInfo, this.time, this.user, this.nid});

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

    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (widget.time * 60);

    controllerTime =
        CountdownTimerController(endTime: endTime, onEnd: _onFinishTime);

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
                      return Text('Tiempo finalizado');
                    }
                    return Text(
                      '${time.min} : ${time.sec}',
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
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '¡ENVIAR EVALUACION!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'lorem mas lorem mas lomrem',
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

                  //   _result(respuesta.status.restEvaluacion);
                  // });

                  _result();
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
    print(preguntasList);

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('!TIEMPO FINALIZADO!'),
        content: const Text('lorem mas lorem mas lomrem'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Enviar');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// resivir el resultado /////

  _result() {
    String title = 'EVALUACIÓN MAYO 2021 - AV ';
    String puntaje = '10';

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'EVALUACION',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: Container(
          height: 200.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                    text: "EVALUACION: ",
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
                    text: "Puntaje: ",
                    style: TextStyle(color: mainColor),
                    children: [
                      TextSpan(
                          text: '$puntaje %',
                          style: TextStyle(color: Colors.black))
                    ]),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'CANCELAR',
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
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
  }
}
