import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Noticias/bloc/single/noticiasingle_bloc.dart';
import 'package:universidad_lg/Noticias/services/noticias_single_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class NoticiaSinglePage extends StatelessWidget {
  final User user;
  final String nid;

  const NoticiaSinglePage({Key key, this.user, this.nid}) : super(key: key);

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
        ),
        endDrawer: DrawerMenuRight(
          user: user,
        ),
        body: BlocProvider<NoticiasingleBloc>(
          create: (context) => NoticiasingleBloc(
            servive: IsServiceNoticiasSingle(),
          ),
          child: _ContentSingleNoticia(user: user, nid: nid),
        ));
  }
}

class _ContentSingleNoticia extends StatefulWidget {
  final User user;
  final String nid;

  const _ContentSingleNoticia({Key key, this.user, this.nid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => __ContentSingleNoticia();
}

class __ContentSingleNoticia extends State<_ContentSingleNoticia> {
  @override
  void initState() {
    super.initState();
    _loadDataSingleNoticia();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: BlocBuilder<NoticiasingleBloc, NoticiasingleState>(
        builder: (context, state) {
          final streamingBloc = BlocProvider.of<NoticiasingleBloc>(context);

          if (state is NoticiasingleSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      'NOTICIA',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.data.status.data.title,
                      style: TextStyle(
                          fontSize: 24,
                          height: 1.15,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      key: Key('body'),
                      data: state.data.status.data.body,
                      style: {'a': Style(color: mainColor)},
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ErrorNoticiasingle) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(state.message),
                TextButton(
                  child: Text('Volver a intentar'),
                  onPressed: () {
                    streamingBloc.add(
                      GetSingleNoticiaEvent(
                          user: widget.user.userId,
                          token: widget.user.token,
                          nid: widget.nid),
                    );
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

  void _loadDataSingleNoticia() {
    final blocSingleStreaming = BlocProvider.of<NoticiasingleBloc>(context);
    blocSingleStreaming.add(
      GetSingleNoticiaEvent(
          user: widget.user.userId, token: widget.user.token, nid: widget.nid),
    );
  }
}
