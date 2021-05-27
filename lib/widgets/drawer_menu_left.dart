import 'package:flutter/material.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/constants.dart';

class DrawerMenuLeft extends StatelessWidget {
  final User user;
  const DrawerMenuLeft({
    this.user,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => HomePage(),
                  child: Image(
                    image: AssetImage('assets/img/new_logo.png'),
                    height: 40,
                  ),
                ),
                Text(
                  user.name,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Entrenamiento'),
          ),
          ListTile(
            leading: Icon(Icons.history_edu),
            title: Text('Evaluación'),
          ),
          ListTile(
            leading: Icon(Icons.collections_bookmark),
            title: Text('Biblioteca'),
          ),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('Club'),
          ),
          ListTile(
            leading: Icon(Icons.cast_for_education),
            title: Text('Streamings'),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda'),
          ),
        ],
      ),
    );
  }
}
