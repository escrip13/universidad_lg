import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Biblioteca/bloc/biblioteca_bloc.dart';
import 'package:universidad_lg/Biblioteca/models/biblioteca_model.dart';
import 'package:universidad_lg/Biblioteca/pages/single_biblioteca_page.dart';
import 'package:universidad_lg/Biblioteca/services/biblioteca_services.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class BibliotecaPage extends StatelessWidget {
  final User user;

  const BibliotecaPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
        currenPage: 'biblioteca',
      ),
      endDrawer: DrawerMenuRight(
        user: user,
      ),
      body: BlocProvider<BibliotecaBloc>(
        create: (context) => BibliotecaBloc(service: IsBibliotecaService()),
        child: _ContentBibliotecaPage(user: user),
      ),
    );
  }
}

class _ContentBibliotecaPage extends StatefulWidget {
  final User user;

  const _ContentBibliotecaPage({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => __ContentBibliotecaPage();
}

class __ContentBibliotecaPage extends State<_ContentBibliotecaPage> {
  String filtro = 'none';
  String categoria = 'none';

  Biblioteca data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataBiblioteca();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<BibliotecaBloc, BibliotecaState>(
      listener: (context, state) {
        if (state is BibliotecaChangeFilter) {
          setState(() {
            filtro = state.filtro;
          });
        }
        if (state is BibliotecaChangeCategoria) {
          categoria = state.categoria;
        }
      },
      child: Container(
        child: BlocBuilder<BibliotecaBloc, BibliotecaState>(
          builder: (context, state) {
            final bibliotecaBloc = BlocProvider.of<BibliotecaBloc>(context);

            if (state is BibliotecaSucess) {
              data = state.data;
              return RefreshIndicator(
                  onRefresh: () async {
                    filtro = 'none';
                    bibliotecaBloc.add(GetBibliotecaEvent(
                        user: widget.user.userId, token: widget.user.token));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            state.data.status.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                ),
                                child: _ItemFiltros(
                                    item: state.data.status.data.filtros)),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: mainColor,
                              ),
                              child: _ItemCategorias(
                                item: state.data.status.data.filtrosCate,
                                filtro: filtro,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        for (var item in state.data.status.data.biblioteca)
                          _ItemBiblioteca(
                            item: item,
                            user: widget.user,
                            filter: filtro,
                            categoria: categoria,
                          ),
                      ],
                    ),
                  ));
            }

            if (state is BibliotecaChangeFilter ||
                state is BibliotecaChangeCategoria) {
              return RefreshIndicator(
                  onRefresh: () async {
                    filtro = 'none';
                    bibliotecaBloc.add(GetBibliotecaEvent(
                        user: widget.user.userId, token: widget.user.token));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            data.status.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                ),
                                child: _ItemFiltros(
                                    item: data.status.data.filtros)),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: mainColor,
                              ),
                              child: _ItemCategorias(
                                item: data.status.data.filtrosCate,
                                filtro: filtro,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        for (var item in data.status.data.biblioteca)
                          _ItemBiblioteca(
                            item: item,
                            user: widget.user,
                            filter: filtro,
                            categoria: categoria,
                          ),
                      ],
                    ),
                  ));
            }

            return Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            );
          },
        ),
      ),
    );
  }

  void _getDataBiblioteca() {
    final bibliotecaBloc = BlocProvider.of<BibliotecaBloc>(context);

    bibliotecaBloc.add(
        GetBibliotecaEvent(user: widget.user.userId, token: widget.user.token));
  }
}

class _ItemFiltros extends StatefulWidget {
  final List<Filtro> item;

  const _ItemFiltros({Key key, this.item}) : super(key: key);

  @override
  __ItemFiltrosState createState() => __ItemFiltrosState();
}

class __ItemFiltrosState extends State<_ItemFiltros> {
  String dropdownValueFiltro;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValueFiltro = widget.item[0].tid;
  }

  @override
  Widget build(BuildContext context) {
    final bibliotecaBloc = BlocProvider.of<BibliotecaBloc>(context);

    return DropdownButtonFormField<String>(
      value: dropdownValueFiltro,
      isExpanded: true,
      elevation: 16,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      dropdownColor: mainColor,
      onChanged: (String newValue) {
        setState(() {
          dropdownValueFiltro = newValue;

          bibliotecaBloc.add(FiterBibliotecaEvent(filtro: newValue));
        });
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 0),
        ),
      ),
      items: widget.item.map((e) {
        return DropdownMenuItem<String>(
          value: e.tid,
          child: Text(
            e.name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ItemCategorias extends StatefulWidget {
  final List<FiltrosCate> item;
  final String filtro;

  const _ItemCategorias({Key key, this.item, this.filtro}) : super(key: key);
  @override
  __ItemCategoriasState createState() => __ItemCategoriasState();
}

class __ItemCategoriasState extends State<_ItemCategorias> {
  String dropdownValue;
  List<FiltrosCate> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // data = widget.item;
    data = widget.item;

    dropdownValue = data[0].tid;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BibliotecaBloc, BibliotecaState>(
      listener: (context, state) {
        if (state is BibliotecaChangeFilter) {
          setState(() {});
          dropdownValue = data[0].tid;
        }
      },
      child: BlocBuilder<BibliotecaBloc, BibliotecaState>(
        builder: (context, state) {
          final bibliotecaBloc = BlocProvider.of<BibliotecaBloc>(context);
          if (state is BibliotecaChangeFilter) {
            data = [];
            if (widget.filtro == 'none') {
              data = widget.item;
            } else {
              data.add(widget.item.first);
              for (var item in widget.item) {
                if (widget.filtro == item.parent && widget.filtro != 'none') {
                  data.add(item);
                }
              }
            }
          }

          return DropdownButtonFormField<String>(
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
                bibliotecaBloc
                    .add(CategoriaBibliotecaEvent(categoria: newValue));
              });
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: mainColor, width: 0),
              ),
              // hintText: Text('sss');
            ),
            items: data.map((e) {
              return DropdownMenuItem<String>(
                value: e.tid,
                child: Text(
                  e.name,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _ItemBiblioteca extends StatelessWidget {
  final BibliotecaElement item;
  final User user;
  final String filter;
  final String categoria;

  const _ItemBiblioteca(
      {Key key, this.item, this.user, this.filter, this.categoria})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (filter == "none" && categoria == "none") {
      return Container(
        // margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: item.uri,
              placeholder: (context, url) => CircularProgressIndicator(
                color: mainColor,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ButtomMain(
                    text: 'VER MÁS',
                    onpress: SingleBibliotecaPage(
                      user: user,
                      data: item,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else if (filter == item.filtro && categoria == 'none') {
      return Container(
        // margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: item.uri,
              placeholder: (context, url) => CircularProgressIndicator(
                color: mainColor,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ButtomMain(
                    text: 'VER MÁS',
                    onpress: SingleBibliotecaPage(
                      user: user,
                      data: item,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else if (categoria == item.cate && filter == 'none') {
      return Container(
        // margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: item.uri,
              placeholder: (context, url) => CircularProgressIndicator(
                color: mainColor,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ButtomMain(
                    text: 'VER MÁS',
                    onpress: SingleBibliotecaPage(
                      user: user,
                      data: item,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else if (filter == item.filtro && categoria == item.cate) {
      return Container(
        // margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: item.uri,
              placeholder: (context, url) => CircularProgressIndicator(
                color: mainColor,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ButtomMain(
                    text: 'VER MÁS',
                    onpress: SingleBibliotecaPage(
                      user: user,
                      data: item,
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
