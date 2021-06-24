import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Streaming/blog/bloc/single/streamingsingle_bloc.dart';
import 'package:universidad_lg/Streaming/services/streaming_single_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class StreamingSinglePage extends StatelessWidget {
  final User user;
  final String nid;

  const StreamingSinglePage({Key key, this.user, this.nid}) : super(key: key);

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
        body: BlocProvider<StreamingsingleBloc>(
          create: (context) => StreamingsingleBloc(
            servive: IsServiceStreamingSingle(),
          ),
          child: _ContentSingleStreaming(user: user, nid: nid),
        ));
  }
}

class _ContentSingleStreaming extends StatefulWidget {
  final User user;
  final String nid;

  const _ContentSingleStreaming({Key key, this.user, this.nid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => __ContentSingleStreaming();
}

class __ContentSingleStreaming extends State<_ContentSingleStreaming> {
  @override
  void initState() {
    super.initState();
    _loadDataSingleStreaming();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: BlocBuilder<StreamingsingleBloc, StreamingsingleState>(
        builder: (context, state) {
          final streamingBloc = BlocProvider.of<StreamingsingleBloc>(context);

          if (state is StreamingsingleSuccess) {
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
                      'STREAMIGS',
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
                  Html(
                    key: Key('iframe'),
                    data:
                        '<iframe  width="${MediaQuery.of(context).size.width}" src="https://www.youtube.com/embed/${state.data.status.data.iframe}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
                    style: {
                      'iframe': Style(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20))
                    },
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

          if (state is ErrorStreamingsingle) {
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
                      GetSingleStramingEvent(
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

  void _loadDataSingleStreaming() {
    final blocSingleStreaming = BlocProvider.of<StreamingsingleBloc>(context);
    blocSingleStreaming.add(
      GetSingleStramingEvent(
          user: widget.user.userId, token: widget.user.token, nid: widget.nid),
    );
  }
}
