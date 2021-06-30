import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:universidad_lg/Entrenamiento/models/activetestsalida_model.dart';
import 'package:universidad_lg/Entrenamiento/pages/cursopreview_page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento_bloc.dart';
import 'package:universidad_lg/Entrenamiento/models/leccion_model.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';

import 'package:universidad_lg/User/models/user.dart';

import '../../constants.dart';

CountdownTimerController controllerTime;

class LeccionPage extends StatefulWidget {
  final User user;
  final String curso;
  final String leccion;
  final String parent;
  const LeccionPage({
    Key key,
    @required this.user,
    @required this.curso,
    @required this.leccion,
    this.parent,
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
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) {
                  return HomePage(
                    user: widget.user,
                  );
                }), (route) => false);
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
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    CursoPreviewPage(user: widget.user, nid: widget.parent),
              ),
            );

            return false;
          },
          child: _LeccionContent(
            user: widget.user,
            curso: widget.curso,
            leccion: widget.leccion,
          ),
        ));
  }
}

class _LeccionContent extends StatefulWidget {
  final User user;
  final String curso;
  final String leccion;
  _LeccionContent({this.user, this.curso, this.leccion});
  @override
  __LeccionContentState createState() => __LeccionContentState();
}

class __LeccionContentState extends State<_LeccionContent> {
  Leccion leccion;
  bool load = false;
  EntrenamientoBloc leccionBloc = EntrenamientoBloc();
  int endTime = 0;

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

    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (2 * 60);
    // controllerTime =
    //     CountdownTimerController(endTime: endTime, onEnd: _onFinishTime);

    // Activar Test Salida
    leccionBloc
        .activeTestSalida(
      uid: widget.user.userId,
      token: widget.user.token,
      curso: widget.curso,
    )
        .then((value) {
      ActiveTestSalida respuesta = value;
      // print('pasa');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // controllerTime.disposeTimer();
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
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    width: double.infinity,
                    child: Html(
                      key: Key('iframe'),
                      data:
                          '<iframe height="${MediaQuery.of(context).size.height - 250} "  width="${MediaQuery.of(context).size.width}"+ src="https://docs.google.com/gview?url=${leccion.status.data.curso.datos}&embedded=true" frameborder="0" ></iframe>',
                      style: {
                        'iframe': Style(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(20))
                      },
                    ),
                  ),
                  // CountdownTimer(
                  //   controller: controllerTime,
                  // ),
                ],
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
    // print('dddd');

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text(
            '¡Enhorabuena!',
            textAlign: TextAlign.center,
            style: TextStyle(color: mainColor),
          ),
          content: const Text(
              'Has tomado todo el curso, ahora puedes realizar el Test de Salida, ¡Suerte!'),
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
                Navigator.pop(context, 'pasa');
                // validadcion deregreso
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        VideoPlayerController.network(widget.leccion.status.data.curso.datos)
          ..initialize().then((_) {
            setState(() {});
          });
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
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.all(0),
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
  }
}
