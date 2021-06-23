import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Home/pages/home_page.dart';
import 'User/pages/pages.dart';
import 'User/blocs/authentication/authentication_bloc.dart';
import 'User/blocs/authentication/authentication_event.dart';
import 'User/blocs/authentication/authentication_state.dart';
import 'User/services/authentication_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

void main() => runApp(

        // Injects the Authentication service
        RepositoryProvider<AuthenticationService>(
      create: (context) {
        return IsAuthenticationService();
      },
      // Injects the Authentication BLoC
      child: BlocProvider<AuthenticationBloc>(
        create: (context) {
          final authService =
              RepositoryProvider.of<AuthenticationService>(context);
          return AuthenticationBloc(authService)..add(AppLoaded());
        },
        child: MyApp(),
      ),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universidad LG',
      theme: ThemeData(
        textTheme: GoogleFonts.titilliumWebTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print(state);
          if (state is AuthenticationAuthenticated) {
            // show home page
            return HomePage(
              user: state.user,
            );
          }
          // otherwise show login page

          if (state is AuthenticationNotAuthenticated) {
            return LoginPage();
          }
          if (state is AuthenticationNotCode) {
            return LoginPage();
          }
          // print(state);
          return Center(
            child: CircularProgressIndicator(color: mainColor),
          );
        },
      ),
    );
  }
}
