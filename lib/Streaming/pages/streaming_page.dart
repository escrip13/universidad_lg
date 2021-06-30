import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/Streaming/blog/bloc/general/streaming_bloc.dart';
import 'package:universidad_lg/Streaming/models/streaming_model.dart';
import 'package:universidad_lg/Streaming/pages/streaming_single_page.dart';
import 'package:universidad_lg/Streaming/services/streaming_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class StreamingPage extends StatelessWidget {
  final User user;

  const StreamingPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
        currenPage: 'streaming',
      ),
      endDrawer: DrawerMenuRight(
        user: user,
      ),
      body: BlocProvider<StreamingBloc>(
        create: (context) => StreamingBloc(service: IsStreamingService()),
        child: _ContentSteamingPage(user: user),
      ),
    );
  }
}

class _ContentSteamingPage extends StatefulWidget {
  final User user;

  const _ContentSteamingPage({Key key, this.user}) : super(key: key);
  @override
  __ContentSteamingPageState createState() => __ContentSteamingPageState();
}

class __ContentSteamingPageState extends State<_ContentSteamingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadStreamingData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: BlocBuilder<StreamingBloc, StreamingState>(
        builder: (context, state) {
          final streamingBloc = BlocProvider.of<StreamingBloc>(context);

          if (state is StreamingSuccess) {
            return RefreshIndicator(
                onRefresh: () async {
                  streamingBloc.add(GetSreamingEvent(
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
                          'STREAMIGS',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      for (var item in state.data.status.data)
                        _ItemStreaming(item: item, user: widget.user),
                    ],
                  ),
                ));
          }

          if (state is ErrorStreaming) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(state.message),
                TextButton(
                  child: Text('Volver a intentar'),
                  onPressed: () {
                    streamingBloc.add(GetSreamingEvent(
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

  void _loadStreamingData() {
    final streamingBloc = BlocProvider.of<StreamingBloc>(context);
    streamingBloc.add(
        GetSreamingEvent(token: widget.user.token, user: widget.user.userId));
  }
}

class _ItemStreaming extends StatelessWidget {
  final Datum item;
  final User user;

  const _ItemStreaming({Key key, this.item, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      child: Column(
        children: [
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
            Container(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                // width: double.infinity,
                imageUrl: item.uri,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: mainColor,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'EMITIDO EL ${item.created}',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
            )
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
                    fontSize: 20.0,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 15.0),
                ButtomMain(
                  text: 'VER',
                  onpress: StreamingSinglePage(
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
