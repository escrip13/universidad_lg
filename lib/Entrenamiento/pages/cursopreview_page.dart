import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento_bloc.dart';
import 'package:universidad_lg/Entrenamiento/models/cursopreview_model.dart';
import 'package:universidad_lg/Entrenamiento/pages/leccion_page.dart';
import 'package:universidad_lg/Entrenamiento/pages/testentrada_page.dart';
import 'package:universidad_lg/Entrenamiento/pages/testsalida_page.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_bloc.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_state.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';

class CursoPreviewPage extends StatefulWidget {
  final User user;
  final String nid;

  const CursoPreviewPage({
    Key key,
    @required this.user,
    @required this.nid,
  }) : super(key: key);

  @override
  _CursoPreviewPageState createState() => _CursoPreviewPageState();
}

class _CursoPreviewPageState extends State<CursoPreviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page

            return _CursoPreviewContent(
              user: state.user,
              nid: widget.nid,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}

class _CursoPreviewContent extends StatefulWidget {
  User user;
  String nid;
  _CursoPreviewContent({this.user, this.nid});
  @override
  __CursoPreviewContentState createState() => __CursoPreviewContentState();
}

class __CursoPreviewContentState extends State<_CursoPreviewContent> {
  CursoPreview cursoPreview;
  bool load = false;
  String _textTestEntrada;
  bool acceso = false;
  EntrenamientoBloc cursoPreviewBloc = EntrenamientoBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void loadData() {
    cursoPreviewBloc
        .getCursoPreviewContent(
            token: widget.user.token,
            uid: widget.user.userId,
            curso: widget.nid)
        .then((value) {
      _onLoad();
      cursoPreview = value;
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
      print(cursoPreview.status.data.curso.video);
      return Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            if (cursoPreview.status.data.curso.video.isEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.8),
                child: CachedNetworkImage(
                  imageUrl: cursoPreview.status.data.curso.uri,
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: mainColor,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )
            else
              _VideoPlayerLeccion(cursoPreview.status.data.curso.video),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${cursoPreview.status.data.curso.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Html(
                    data: cursoPreview.status.data.curso.bodyValue,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      if (cursoPreview.status.data.testEntrada == 0 ||
                          cursoPreview.status.data.testEntrada == 2) {
                        acceso = true;
                        _textTestEntrada =
                            'Por favor lee detenidamente cada una de las preguntas y opciones de respuesta a continuación. Debes disponer de ${cursoPreview.status.data.testTiempo} minutos, una buena conexión a internet, no cierres o salgas de la aplicación.';
                      } else {
                        acceso = false;
                        _textTestEntrada =
                            'Este Test de Entrada ya fue realizado y no puede repetirse, debes continuar el curso.';
                      }

                      _viewTestEntrada(_textTestEntrada, acceso);
                    },
                    child: const Text('TEST DE ENTRADA'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      if (cursoPreview.status.data.testEntrada == 1 ||
                          cursoPreview.status.data.testEntrada == 2) {
                        _textTestEntrada = 'Continuar';
                        acceso = true;
                      } else {
                        _textTestEntrada =
                            'Primero debes completar el Test de Entrada para ingresar al contenido del curso.';
                        acceso = false;
                      }

                      _viewLeccion(_textTestEntrada, acceso);
                    },
                    child: const Text('VER CURSO'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      if ((cursoPreview.status.data.testEntrada == 1 &&
                              cursoPreview.status.data.testSalida == 0 &&
                              cursoPreview.status.data.verCurso == 1) ||
                          (cursoPreview.status.data.testEntrada == 2 &&
                              cursoPreview.status.data.testSalida == 0 &&
                              cursoPreview.status.data.verCurso == 1)) {
                        acceso = true;
                        _textTestEntrada =
                            'Por favor lee detenidamente cada una de las preguntas y opciones de respuesta a continuación. Debes disponer de ${cursoPreview.status.data.testTiempo} minutos, una buena conexión a internet, no cierres o salgas de la aplicación.';
                      }

                      if (cursoPreview.status.data.testSalida == 1 &&
                          cursoPreview.status.data.verCurso == 1) {
                        acceso = false;
                        _textTestEntrada =
                            'Este Test de Salida ya fue realizado y no puede repetirse.';
                      }

                      if (cursoPreview.status.data.testEntrada == 0 ||
                          cursoPreview.status.data.verCurso == 0) {
                        acceso = false;
                        _textTestEntrada =
                            'Primero debes terminar el Test de Entrada y luego ver el curso para tomar este Test de Salida.';
                      }

                      if ((cursoPreview.status.data.testEntrada == 1 &&
                              cursoPreview.status.data.verCurso == 0) ||
                          cursoPreview.status.data.testEntrada == 2 ||
                          cursoPreview.status.data.verCurso == 0) {
                        acceso = false;
                        _textTestEntrada =
                            'Debes ver el curso para tomar este Test de Salida.';
                      }

                      _viewTestSalida(_textTestEntrada, acceso);
                    },
                    child: const Text('TEST DE SALIDA'),
                  )
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

  _viewTestEntrada(String textDinamic, bool acceso) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '¡Ten presente!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor, fontWeight: FontWeight.w600),
        ),
        content: Text(
          _textTestEntrada,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  if (acceso) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestEntradaPage(
                                parent: widget.nid,
                                user: widget.user,
                                curso: cursoPreview.status.data.curso.nid,
                                leccion: cursoPreview.status.data.leccionId)));
                  }

                  return false;
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: mainColor, fontSize: 18.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _viewLeccion(String textDinamic, bool acceso) async {
    if (acceso) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeccionPage(
            user: widget.user,
            curso: cursoPreview.status.data.curso.nid,
            leccion: cursoPreview.status.data.leccionId,
            parent: widget.nid,
          ),
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            '¡Ten presente!',
            textAlign: TextAlign.center,
            style: TextStyle(color: mainColor, fontWeight: FontWeight.w600),
          ),
          content: Text(
            textDinamic,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    return false;
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: mainColor, fontSize: 18.0),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  _viewTestSalida(String textDinamic, bool acceso) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '¡Ten presente!',
          textAlign: TextAlign.center,
          style: TextStyle(color: mainColor, fontWeight: FontWeight.w600),
        ),
        content: Text(
          _textTestEntrada,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  if (acceso) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestSalidaPage(
                                user: widget.user,
                                curso: cursoPreview.status.data.curso.nid,
                                leccion: cursoPreview.status.data.leccionId)));
                  }

                  return false;
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: mainColor, fontSize: 18.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _VideoPlayerLeccion extends StatefulWidget {
  final String video;
  _VideoPlayerLeccion(this.video);
  @override
  __VideoPlayerLeccion createState() => __VideoPlayerLeccion();
}

class __VideoPlayerLeccion extends State<_VideoPlayerLeccion>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  FlickManager flickManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = VideoPlayerController.network(widget.video)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.video),
    );

    // _controller.value.duration;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(10.5),
      child: FlickVideoPlayer(flickManager: flickManager),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
    _controller.dispose();
  }
}
