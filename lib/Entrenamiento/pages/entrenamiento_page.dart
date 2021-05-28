import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento.dart';
import 'package:universidad_lg/Entrenamiento/models/models.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import '../../constants.dart';

class EntrenamientoPage extends StatelessWidget {
  const EntrenamientoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            onTap: () => EntrenamientoPage(),
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
      backgroundColor: mainColor,
      drawer: DrawerMenuLeft(),
      endDrawer: DrawerMenuRight(),

      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page

            return _EntrenamientoContent(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
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

  void _incrementCounter() {
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    entrenamientoBloc
        .getEntrenamintoContent(
            token: widget.user.token, uid: widget.user.userId)
        .then((value) {
      _incrementCounter();
      entrenamientoInfo = value;
    });

    if (load) {
      return Container(
        // padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}
