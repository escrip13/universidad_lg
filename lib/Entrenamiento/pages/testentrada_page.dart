import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:universidad_lg/Entrenamiento/models/sendtestentrada_model.dart';
import 'package:universidad_lg/Entrenamiento/pages/cursopreview_page.dart';
import '../../constants.dart';

import 'package:universidad_lg/Entrenamiento/models/testentrada_model.dart';
import 'package:universidad_lg/User/models/models.dart';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';
import 'package:flutter_countdown_timer/index.dart';

import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento_bloc.dart';

Map preguntasList = {};
CountdownTimerController controllerTime;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class TestEntradaPage extends StatefulWidget {
  final String parent;
  final User user;
  final String curso;
  final String leccion;

  const TestEntradaPage({
    Key key,
    @required this.user,
    @required this.curso,
    @required this.leccion,
    this.parent,
  }) : super(key: key);

  @override
  _TestEntradaPageState createState() => _TestEntradaPageState();
}

class _TestEntradaPageState extends State<TestEntradaPage> {
  EntrenamientoBloc testEntradaBloc = EntrenamientoBloc();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
          key: _scaffoldKey,
          // backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: Center(
              child: InkWell(
                // onTap: () {
                //   Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => HomePage(
                //                 user: widget.user,
                //               )));
                // },
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
            user: widget.user,
            curso: widget.curso,
            leccion: widget.leccion,
            parent: widget.parent,
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
          '¿DESEA REGRESAR?',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor),
        ),
        content: const Text(
          'Se enviará la información prevista hasta el momento',
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
                  testEntradaBloc
                      .sendTestEntrada(
                          data: preguntasList,
                          uid: widget.user.userId,
                          token: widget.user.token,
                          curso: widget.curso,
                          leccion: widget.leccion)
                      .then((value) {
                    SendTestEntrada respuesta = value;

                    _result(
                        context: context,
                        res: respuesta.status.dataTest,
                        user: widget.user,
                        id: widget.curso,
                        parent: widget.parent);
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

class _TestEntradaContent extends StatefulWidget {
  final User user;
  final String curso;
  final String leccion;
  final String parent;
  _TestEntradaContent({this.user, this.curso, this.leccion, this.parent});
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
          parent: widget.parent,
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
  final int time;
  final User user;
  final String curso;
  final String leccion;
  final String parent;

  _ContentTestEntrada(
      {this.testEntradaInfo,
      this.time,
      this.user,
      this.curso,
      this.leccion,
      this.parent});

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

  Animatable<double> bgValue = Tween<double>(begin: 0.0, end: 10.0);

  Rainbow rb = Rainbow(rangeStart: 0.0, rangeEnd: 10.0, spectrum: [
    Colors.green,
    Colors.yellow,
    mainColor,
  ]);

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
                context: this.context,
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
    // return steps;
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
          'Se enviará tu test de entrada.',
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
                  testEntradaBloc
                      .sendTestEntrada(
                          data: preguntasList,
                          uid: widget.user.userId,
                          token: widget.user.token,
                          curso: widget.curso,
                          leccion: widget.leccion)
                      .then((value) {
                    SendTestEntrada respuesta = value;

                    _result(
                        context: context,
                        res: respuesta.status.dataTest,
                        user: widget.user,
                        id: widget.curso,
                        parent: widget.parent);
                  });

                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute<void>(
                  //         builder: (BuildContext context) =>
                  //             EntrenamientoPage(user: widget.user)));
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
              'Te has tomado más tiempo de lo previsto, intentalo a la próxima.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                testEntradaBloc
                    .sendTestEntrada(
                        data: preguntasList,
                        uid: widget.user.userId,
                        token: widget.user.token,
                        curso: widget.curso,
                        leccion: widget.leccion)
                    .then((value) {
                  SendTestEntrada respuesta = value;

                  _result(
                    context: context,
                    res: respuesta.status.dataTest,
                    user: widget.user,
                    id: widget.curso,
                    parent: widget.parent,
                  );
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

  @override
  void dispose() {
    // detroy de la animacion
    super.dispose();
    controllerAnimation.dispose();
  }
}

_result({DataTest res, User user, context, String id, String parent}) {
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
                    text: "TEST DE ENTRADA: ",
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
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  // Navigator.pop(context);

                  // debe haber un forma de retocedder el nav hasta un  punto
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              CursoPreviewPage(user: user, nid: parent)));
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
