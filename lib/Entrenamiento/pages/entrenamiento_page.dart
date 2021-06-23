import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento.dart';
import 'package:universidad_lg/Entrenamiento/models/models.dart';
import 'package:universidad_lg/Entrenamiento/pages/cursopreview_page.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/models.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants.dart';

class EntrenamientoPage extends StatelessWidget {
  final User user;
  const EntrenamientoPage({
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
        currenPage: 'entrenamiento',
      ),
      endDrawer: DrawerMenuRight(
        user: user,
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page

            return _EntrenamientoContent(
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

class _EntrenamientoContent extends StatefulWidget {
  final User user;
  const _EntrenamientoContent({Key key, this.user}) : super(key: key);
  @override
  __EntrenamientoContent createState() => __EntrenamientoContent();
}

class __EntrenamientoContent extends State<_EntrenamientoContent> {
  Entrenamiento entrenamientoInfo;
  bool load = false;
  EntrenamientoBloc entrenamientoBloc = EntrenamientoBloc();
  int filtro = 0;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void _changeFilter(value) {
    if (mounted) {
      setState(() {
        filtro = value;
      });
    }
  }

  void getFilterEntreteniminto({context, List<Filtro> data}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    tileColor: filtro == 0 ? mainColor : null,
                    title: Text(
                      'TOODAS LAS CATEGORIAS',
                      style:
                          TextStyle(color: filtro == 0 ? Colors.white : null),
                    ),
                    onTap: () {
                      _changeFilter(0);

                      Navigator.pop(context);
                    }),
                for (var fil in data)
                  ListTile(
                      tileColor:
                          filtro == int.parse(fil.tid) ? mainColor : null,
                      title: Text(
                        fil.name,
                        style: TextStyle(
                            color: filtro == int.parse(fil.tid)
                                ? Colors.white
                                : null),
                      ),
                      onTap: () {
                        _changeFilter(int.parse(fil.tid));
                        Navigator.pop(context);
                      }),
              ],
            ),
          );
        });
  }

  void loadData() {
    entrenamientoBloc
        .getEntrenamientoContent(
            token: widget.user.token, uid: widget.user.userId)
        .then((value) {
      _onLoad();
      entrenamientoInfo = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    if (load) {
      return Container(
          // padding: EdgeInsets.all(0),
          child: Stack(
        children: [
          _ContentEntrenamiento(entrenamientoInfo, filtro),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                getFilterEntreteniminto(
                    context: context, data: entrenamientoInfo.status.filtros);
              },
              child: const Icon(Icons.settings),
              backgroundColor: mainColor,
            ),
          )
        ],
      ));
    }

    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}

class _ContentEntrenamiento extends StatefulWidget {
  Entrenamiento entrenamientoInfo;
  int filtro;

  _ContentEntrenamiento(this.entrenamientoInfo, this.filtro);

  @override
  __ContentEntrenamientoState createState() => __ContentEntrenamientoState();
}

class __ContentEntrenamientoState extends State<_ContentEntrenamiento> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  unselectedLabelColor: mainColor,
                  labelColor: Colors.black54,
                  indicatorColor: mainColor,
                  tabs: [
                    Tab(text: 'BÁSICO'),
                    Tab(text: 'INTERMEDIO'),
                    Tab(text: 'AVANZADO'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      _ContentEntrenamintoType(
                        data: widget.entrenamientoInfo.status.cursos.basico,
                        filtro: widget.filtro,
                      ),
                      //
                      _ContentEntrenamintoType(
                        data: widget.entrenamientoInfo.status.cursos.intermedio,
                        filtro: widget.filtro,
                      ),
                      _ContentEntrenamintoType(
                        data: widget.entrenamientoInfo.status.cursos.avanzado,
                        filtro: widget.filtro,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContentEntrenamintoType extends StatelessWidget {
  final Map<String, TipoCurso> data;
  final int filtro;
  _ContentEntrenamintoType({this.data, this.filtro});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'ENTRENAMIENTO',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            for (var curso in data.values)
              _ItemCurso(
                curso: curso,
                filtro: filtro,
              )
          ],
        ),
      ),
    );
  }
}

class _ItemCurso extends StatelessWidget {
  TipoCurso curso;
  int filtro;
  User user;

  _ItemCurso({this.curso, this.filtro, this.user});

  @override
  Widget build(BuildContext context) {
    if (filtro == 0) {
      return Container(
        margin: EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: curso.portada,
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
                      ' ${curso.porcentaje}% Desarrollado',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: mainColor),
                    ),
                  ),
                  Text(
                    curso.title,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  ButtomMain(
                      text: 'VER CURSO',
                      onpress: CursoPreviewPage(
                        user: user,
                        nid: curso.nid,
                      ))
                ],
              ),
            )
          ],
        ),
      );
    } else if (filtro == int.parse(curso.categoria)) {
      return Container(
        margin: EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: curso.portada,
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
                      ' ${curso.porcentaje}% Desarrollado',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: mainColor),
                    ),
                  ),
                  Text(
                    curso.title,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  ButtomMain(
                    text: 'VER CURSO',
                    onpress: CursoPreviewPage(
                      user: user,
                      nid: curso.nid,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
