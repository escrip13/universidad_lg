import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/logros/logros_bloc.dart';
import 'package:universidad_lg/User/models/logros.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/services/logros_service.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class PageLogros extends StatelessWidget {
  final User user;
  const PageLogros({Key key, this.user}) : super(key: key);
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
        currenPage: 'logros',
      ),
      body: BlocProvider<LogrosBloc>(
        create: (context) => LogrosBloc(service: IsLogrosService()),
        child: _ContentLogrosPage(user: user),
      ),
    );
  }
}

class _ContentLogrosPage extends StatefulWidget {
  final User user;

  const _ContentLogrosPage({Key key, this.user}) : super(key: key);

  @override
  __ContentLogrosPageState createState() => __ContentLogrosPageState();
}

class __ContentLogrosPageState extends State<_ContentLogrosPage> {
  TextEditingController searchController = new TextEditingController();
  Logros data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLogrosData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: BlocBuilder<LogrosBloc, LogrosState>(builder: (context, state) {
        final blocLogros = BlocProvider.of<LogrosBloc>(context);
        if (state is LogrosSuccess) {
          data = state.data;
        }

        if (state is LogrosLoad) {
          return Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            blocLogros
                .add(GetLogrosEvent(widget.user.userId, widget.user.token));
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Stack(children: [
                  Column(
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
                        margin: EdgeInsets.only(top: 50.0),
                        child: Text(
                          'MIS LOGROS',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      if (state is LogrosSuccess)
                        for (var item in state.data.status.data)
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 1.0),
                                  blurRadius: 7.0,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                if (item.medalla == 'sin-copa')
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    color: Colors.black,
                                    size: 120.0,
                                  ),
                                if (item.medalla == 'oro')
                                  Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFFfbeb39),
                                    size: 120.0,
                                  ),
                                if (item.medalla == 'plata')
                                  Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFFe4e4e4),
                                    size: 120.0,
                                  ),
                                if (item.medalla == 'bronce')
                                  Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFFf8ac2f),
                                    size: 120.0,
                                  ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text('${item.porcentaje} %'),
                                Text(item.titulo),
                              ],
                            ),
                          ),

                      //     for (var item in data.status.data) {
                      //       if (state.title != null) {
                      //         var as = RegExp(state.title, caseSensitive: false)
                      //             .hasMatch(item.titulo);
                      //         print(as);
                      //         print(item.titulo);
                      //       }
                      //     }
                      // }

                      if (state is LogrosSearch)
                        for (var item in data.status.data)
                          if (state.title != null)
                            if (item.titulo
                                .toLowerCase()
                                .contains(state.title.toLowerCase()))
                              Container(
                                margin: EdgeInsets.only(bottom: 20.0),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(0, 1.0),
                                      blurRadius: 7.0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    if (item.medalla == 'sin-copa')
                                      Icon(
                                        Icons.emoji_events_outlined,
                                        color: Colors.black,
                                        size: 120.0,
                                      ),
                                    if (item.medalla == 'oro')
                                      Icon(
                                        Icons.emoji_events,
                                        color: Color(0xFFfbeb39),
                                        size: 120.0,
                                      ),
                                    if (item.medalla == 'plata')
                                      Icon(
                                        Icons.emoji_events,
                                        color: Color(0xFFe4e4e4),
                                        size: 120.0,
                                      ),
                                    if (item.medalla == 'bronce')
                                      Icon(
                                        Icons.emoji_events,
                                        color: Color(0xFFf8ac2f),
                                        size: 120.0,
                                      ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text('${item.porcentaje} %'),
                                    Text(item.titulo),
                                  ],
                                ),
                              )
                    ],
                  ),
                ]),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: searchInput(),
              ),
            ],
          ),
        );
      }),
    );
  }

  void getLogrosData() {
    final blocLogros = BlocProvider.of<LogrosBloc>(context);
    blocLogros.add(GetLogrosEvent(widget.user.userId, widget.user.token));
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
            offset: Offset(0.0, 2.0),
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
                hintText: "Buscar Logros",
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

  void search(String title) {
    final blocLogros = BlocProvider.of<LogrosBloc>(context);
    blocLogros.add(SearchLogrosEvent(title));
  }
}
