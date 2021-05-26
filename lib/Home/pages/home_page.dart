import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/blocs/home/home_bloc.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication_bloc.dart';
import 'package:universidad_lg/User/blocs/blocs.dart';
import 'package:universidad_lg/User/models/user.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Container(
          child: _HomeContent(
            user: user,
          ),
        ));
  }
}

class _HomeContent extends StatefulWidget {
  final User user;
  const _HomeContent({Key key, this.user}) : super(key: key);
  @override
  __HomeContent createState() => __HomeContent();
}

class __HomeContent extends State<_HomeContent> {
  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = HomeBloc();
    homeBloc.getHomeContent(token: widget.user.token, uid: widget.user.userId);

    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(),
          child: Text('Logout'),
          onPressed: () {
            authBloc.add(UserLoggedOut());
          },
        ),
        Text('token: ${widget.user.token} ')
      ],
    );
  }
}
