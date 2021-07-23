import 'package:flutter/material.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento.dart';
import 'package:universidad_lg/Entrenamiento/models/models.dart';
import 'package:universidad_lg/Entrenamiento/pages/cursopreview_page.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/models/models.dart';
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
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) {
                  return HomePage(
                    user: user,
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
        body: _EntrenamientoContent(user: user));
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
  // int filtro = 0;

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

  // void _changeFilter(value) {
  //   if (mounted) {
  //     setState(() {
  //       filtro = value;
  //     });
  //   }
  // }

  // void getFilterEntreteniminto({context, List<Filtro> data}) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Container(
  //           child: Wrap(
  //             children: <Widget>[
  //               for (var fil in data)
  //                 ListTile(
  //                     tileColor:
  //                         filtro == int.parse(fil.tid) ? mainColor : null,
  //                     title: Text(
  //                       fil.name,
  //                       style: TextStyle(
  //                           color: filtro == int.parse(fil.tid)
  //                               ? Colors.white
  //                               : null),
  //                     ),
  //                     onTap: () {
  //                       _changeFilter(int.parse(fil.tid));
  //                       Navigator.pop(context);
  //                     }),
  //             ],
  //           ),
  //         );
  //       });
  // }

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
        child: _ContentEntrenamiento(
          user: widget.user,
          entrenamientoInfo: entrenamientoInfo,
          // filtro: filtro,
        ),
        // Positioned(
        //   bottom: 10.0,
        //   right: 10.0,
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       getFilterEntreteniminto(
        //           context: context, data: entrenamientoInfo.status.filtros);
        //     },
        //     child: const Icon(
        //       Icons.filter_alt,
        //     ),
        //     backgroundColor: mainColor,
        //   ),
        // )
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}

class _ContentEntrenamiento extends StatefulWidget {
  final User user;
  final Entrenamiento entrenamientoInfo;

  _ContentEntrenamiento({this.entrenamientoInfo, this.user});

  @override
  __ContentEntrenamientoState createState() => __ContentEntrenamientoState();
}

class __ContentEntrenamientoState extends State<_ContentEntrenamiento> {
  TextEditingController searchController = new TextEditingController();

  String searchTerm = "";
  int filtro = 0;

  String dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.entrenamientoInfo.status.filtros[0].tid;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'ENTRENAMIENTO',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
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
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        decoration: BoxDecoration(color: mainColor),
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: dropdownValue,
                          isExpanded: true,
                          elevation: 16,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          dropdownColor: mainColor,
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;

                              filtro = int.parse(newValue);
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: mainColor, width: 0),
                            ),
                            // hintText: Text('sss');
                          ),
                          items:
                              widget.entrenamientoInfo.status.filtros.map((e) {
                            return DropdownMenuItem<String>(
                              value: e.tid,
                              child: Text(
                                e.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            _ContentEntrenamintoType(
                              data:
                                  widget.entrenamientoInfo.status.cursos.basico,
                              filtro: filtro,
                              user: widget.user,
                              searchTerm: searchTerm,
                            ),
                            //
                            _ContentEntrenamintoType(
                              data: widget
                                  .entrenamientoInfo.status.cursos.intermedio,
                              filtro: filtro,
                              user: widget.user,
                              searchTerm: searchTerm,
                            ),
                            _ContentEntrenamintoType(
                              data: widget
                                  .entrenamientoInfo.status.cursos.avanzado,
                              filtro: filtro,
                              searchTerm: searchTerm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: searchInput(),
        ),
      ],
    );
  }

  Widget searchInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0.0, 1.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: searchController,
            onChanged: (String value) async {
              search(value);
            },
            decoration: InputDecoration(
                hintText: "Buscar...",
                hintStyle: TextStyle(fontSize: 16.0),
                border: InputBorder.none),
          )),
          InkWell(
              onTap: () {
                search(searchController.text);
                // print(searchController.text);
              },
              child: Container(child: Icon(Icons.search, color: mainColor)))
        ],
      ),
    );
  }

  void search(String value) {
    setState(() {
      searchTerm = value;
    });
  }
}

class _ContentEntrenamintoType extends StatelessWidget {
  final Map<String, TipoCurso> data;
  final int filtro;
  final User user;
  final String searchTerm;
  _ContentEntrenamintoType(
      {this.data, this.filtro, this.user, this.searchTerm});

  @override
  Widget build(BuildContext context) {
    print(searchTerm.isNotEmpty);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: Future.value(data.values),
                builder: (BuildContext context,
                    AsyncSnapshot<Iterable<TipoCurso>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var curso in snapshot.data)
                          if (curso.title
                              .toLowerCase()
                              .contains(searchTerm.toLowerCase()))
                            _ItemCurso(
                              curso: curso,
                              filtro: filtro,
                              user: user,
                            )
                      ],
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}

class _ItemCurso extends StatelessWidget {
  final TipoCurso curso;
  final int filtro;
  final User user;

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
