import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:universidad_lg/Entrenamiento/models/activetestsalida_model.dart';
import 'package:video_player/video_player.dart';
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

CountdownTimerController controllerTime;

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

  int endTime = 0;

  @override
  void initState() {
    super.initState();
    loadData();

    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (2 * 60);
    controllerTime =
        CountdownTimerController(endTime: endTime, onEnd: _onFinishTime);

    // Activar Test Salida
    leccionBloc
        .activeTestSalida(
      uid: widget.user.userId,
      token: widget.user.token,
      curso: widget.curso,
    )
        .then((value) {
      ActiveTestSalida respuesta = value;
    });
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
            if (leccion.status.data.curso.tipo == 'VideoLocal')
              _VideoPlayerLeccion(leccion)
            else
              Container(
                height: MediaQuery.of(context).size.height - 200,
                width: double.infinity,
                child: Html(
                  key: Key('iframe'),
                  data:
                      '<iframe height="${MediaQuery.of(context).size.height - 250} "  width="${MediaQuery.of(context).size.width}"+ src="https://docs.google.com/gview?url=${leccion.status.data.curso.datos}&embedded=true" frameborder="0" ></iframe>',
                  style: {
                    'iframe': Style(
                        margin: EdgeInsets.all(20), padding: EdgeInsets.all(20))
                  },
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

  _onFinishTime() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text(
            '¡Enhorabuena!',
            textAlign: TextAlign.center,
            style: TextStyle(color: mainColor),
          ),
          content: const Text(
              'Has tomado toda la lección, ahora puedes realizar el Test de Salida, ¡Suerte!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                leccionBloc
                    .activeTestSalida(
                  uid: widget.user.userId,
                  token: widget.user.token,
                  curso: widget.curso,
                )
                    .then((value) {
                  ActiveTestSalida respuesta = value;
                });
              },
              child: const Text(
                'CONTINUAR',
                style: TextStyle(color: mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayerLeccion extends StatefulWidget {
  final Leccion leccion;
  _VideoPlayerLeccion(this.leccion);
  @override
  __VideoPlayerLeccion createState() => __VideoPlayerLeccion();
}

class __VideoPlayerLeccion extends State<_VideoPlayerLeccion>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  AnimationController controllerAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        VideoPlayerController.network(widget.leccion.status.data.curso.datos)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
    // controllerAnimation = AnimationController(
    //   vsync: this,
    //   duration: Duration(minutes: 10),
    // )..addListener(() {
    //     setState(() {});
    //   });
    // controllerAnimation.repeat(max: 1);
    // controllerAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(10.5),
      child: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Container(
            child: LinearProgressIndicator(
              value: 10.0,
              color: mainColor,
              backgroundColor: secondColor,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () {
              setState(() {
                // Si el vídeo se está reproduciendo, pausalo.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // Si el vídeo está pausado, reprodúcelo
                  _controller.play();
                }
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    controllerAnimation.dispose();
  }
}
