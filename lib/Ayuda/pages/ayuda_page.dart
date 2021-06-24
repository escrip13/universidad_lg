import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Ayuda/bloc/ayuda_bloc.dart';
import 'package:universidad_lg/Ayuda/models/ayuda_model.dart';
import 'package:universidad_lg/Ayuda/services/ayuda_service.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';
import 'ayuda_form_page.dart';

class AyudaPage extends StatelessWidget {
  final User user;
  const AyudaPage({Key key, this.user}) : super(key: key);

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
        currenPage: 'ayuda',
      ),
      endDrawer: DrawerMenuRight(
        user: user,
      ),
      body: BlocProvider<AyudaBloc>(
        create: (context) => AyudaBloc(
          service: IsAyudaService(),
        ),
        child: _ContentAyuda(user: user),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AyudaFormPage(
              user: user,
            );
          }));
        },
      ),
    );
  }
}

class _ContentAyuda extends StatefulWidget {
  final User user;
  const _ContentAyuda({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => __ContentAyuda();
}

class __ContentAyuda extends State<_ContentAyuda> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDataAyuda();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: BlocBuilder<AyudaBloc, AyudaState>(
        builder: (context, state) {
          final ayudaBloc = BlocProvider.of<AyudaBloc>(context);

          if (state is AyudaSuccess) {
            return SingleChildScrollView(
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
                      'AYUDA',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  ExpansionPanelList(
                    elevation: 0,
                    // dividerColor: mainColor,

                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        state.data.status.data[index].isExpanded = !isExpanded;
                      });
                    },
                    children: state.data.status.data
                        .map<ExpansionPanel>((Datum item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            minVerticalPadding: 8.0,
                            title: Text(
                              item.title,
                              style: TextStyle(height: 1.15),
                            ),
                          );
                        },
                        body: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: mainColor))),
                            child: Html(
                              data: item.bodyValue,
                            ),
                          ),
                        ),
                        isExpanded: item.isExpanded,
                        canTapOnHeader: true,
                      );
                    }).toList(),
                  )
                ],
              ),
            );
          }

          if (state is ErrorAyuda) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(state.message),
                TextButton(
                  child: Text('Volver a intentar'),
                  onPressed: () {
                    ayudaBloc.add(GetAyudaEvent(
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

  void _getDataAyuda() {
    final ayudaBlock = BlocProvider.of<AyudaBloc>(context);

    ayudaBlock
        .add(GetAyudaEvent(user: widget.user.userId, token: widget.user.token));
  }
}
