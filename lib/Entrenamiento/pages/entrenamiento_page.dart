import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento.dart';
import 'package:universidad_lg/Entrenamiento/models/models.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/models.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import '../../constants.dart';

class EntrenamientoPage extends StatelessWidget {
  final User user;
  const EntrenamientoPage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            onTap: () {
              return HomePage(
                user: user,
              );
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
        currenPage: 'entrenamiento',
      ),
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

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    entrenamientoBloc
        .getEntrenamintoContent(
            token: widget.user.token, uid: widget.user.userId)
        .then((value) {
      _onLoad();
      entrenamientoInfo = value;
    });

    if (load) {
      return Container(
        // padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            children: [_ContentEntrenamiento()],
          ),
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

class _ContentEntrenamiento extends StatefulWidget {
  @override
  __ContentEntrenamientoState createState() => __ContentEntrenamientoState();
}

class __ContentEntrenamientoState extends State<_ContentEntrenamiento> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        DefaultTabController(
            length: 3,
            child: TabBar(
              unselectedLabelColor: mainColor,
              labelColor: Colors.black54,
              indicatorColor: mainColor,
              tabs: [
                Tab(text: 'BÁSICO'),
                Tab(text: 'INTERMEDIO'),
                Tab(text: 'AVANZADO'),
              ],
            )),
      ],
    );
  }
}
