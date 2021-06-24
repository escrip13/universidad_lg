import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Noticias/bloc/general/noticias_bloc.dart';
import 'package:universidad_lg/Noticias/models/noticias_model.dart';
import 'package:universidad_lg/Noticias/pages/noticias_single_page.dart';
import 'package:universidad_lg/Noticias/services/noticias_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class NoticiasPage extends StatelessWidget {
  final User user;

  const NoticiasPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        currenPage: 'streaming',
      ),
      endDrawer: DrawerMenuRight(
        user: user,
      ),
      body: BlocProvider<NoticiasBloc>(
        create: (context) => NoticiasBloc(service: IsNoticiasService()),
        child: _ContentNoticiasPage(user: user),
      ),
    );
  }
}

class _ContentNoticiasPage extends StatefulWidget {
  final User user;

  const _ContentNoticiasPage({Key key, this.user}) : super(key: key);
  @override
  __ContentNoticiasPageState createState() => __ContentNoticiasPageState();
}

class __ContentNoticiasPageState extends State<_ContentNoticiasPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadNoticiasData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: BlocBuilder<NoticiasBloc, NoticiasState>(
        builder: (context, state) {
          final noticiasBloc = BlocProvider.of<NoticiasBloc>(context);

          if (state is NoticiasSuccess) {
            return RefreshIndicator(
                onRefresh: () async {
                  noticiasBloc.add(GetNoticiasEvent(
                      token: widget.user.token, user: widget.user.userId));
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
                          'NOTICIAS',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      for (var item in state.data.status.data)
                        _ItemNoticias(item: item, user: widget.user),
                    ],
                  ),
                ));
          }

          if (state is ErrorNoticias) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(state.message),
                TextButton(
                  child: Text('Volver a intentar'),
                  onPressed: () {
                    noticiasBloc.add(GetNoticiasEvent(
                        token: widget.user.token, user: widget.user.userId));
                  },
                )
              ],
            ));
          }

          return Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          );
        },
      ),
    );
  }

  void _loadNoticiasData() {
    final noticiasBloc = BlocProvider.of<NoticiasBloc>(context);
    noticiasBloc.add(
        GetNoticiasEvent(token: widget.user.token, user: widget.user.userId));
  }
}

class _ItemNoticias extends StatelessWidget {
  final Datum item;
  final User user;

  const _ItemNoticias({Key key, this.item, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      child: Column(
        children: [
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
            CachedNetworkImage(
              imageUrl: item.uri,
              placeholder: (context, url) => CircularProgressIndicator(
                color: mainColor,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ]),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Column(
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.25,
                    color: mainColor,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  item.bodyValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 15.0),
                ButtomMain(
                  text: 'LEER MÁS',
                  onpress: NoticiaSinglePage(
                    user: user,
                    nid: item.nid,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
