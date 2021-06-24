import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universidad_lg/Biblioteca/models/biblioteca_model.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';

import '../../constants.dart';

class SingleBibliotecaPage extends StatelessWidget {
  final User user;
  final BibliotecaElement data;

  const SingleBibliotecaPage({Key key, this.user, this.data}) : super(key: key);
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
      ),
      endDrawer: DrawerMenuRight(
        user: user,
      ),
      body: _ContentSingleBibliotecaPage(data: data),
    );
  }
}

class _ContentSingleBibliotecaPage extends StatefulWidget {
  final BibliotecaElement data;

  const _ContentSingleBibliotecaPage({Key key, this.data}) : super(key: key);

  @override
  __ContentSingleBibliotecaPageState createState() =>
      __ContentSingleBibliotecaPageState();
}

class __ContentSingleBibliotecaPageState
    extends State<_ContentSingleBibliotecaPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            margin: EdgeInsets.only(bottom: 20.0),
            child: Text(
              widget.data.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          if (widget.data.fieldRecursosTipoValue.toString() ==
              'FieldRecursosTipoValue.VIDEO')
            Container(
              height: MediaQuery.of(context).size.height - 400,
              width: double.infinity,
              child: Html(
                key: Key('iframe'),
                data:
                    '<iframe  width="${MediaQuery.of(context).size.width}" src="https://www.youtube.com/embed/${widget.data.recurso}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
                style: {
                  'iframe': Style(
                      margin: EdgeInsets.all(20), padding: EdgeInsets.all(20))
                },
              ),
            )
          else
            Container(
              height: MediaQuery.of(context).size.height - 200,
              width: double.infinity,
              child: Html(
                key: Key('iframe'),
                data:
                    '<iframe height="${MediaQuery.of(context).size.height - 250} "  width="${MediaQuery.of(context).size.width}"+ src="https://docs.google.com/gview?url=https://107.178.247.254/sites/default/files/oralcom_lavadora_y_refrigeradora.pptx&embedded=true" frameborder="0" ></iframe>',
                style: {
                  'iframe': Style(
                      margin: EdgeInsets.all(20), padding: EdgeInsets.all(20))
                },
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              primary: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text('Volver'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
