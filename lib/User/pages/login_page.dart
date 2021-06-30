import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/pages/pages.dart';
import 'package:universidad_lg/widgets/background_image.dart';
import '../../constants.dart';
import '../blocs/blocs.dart';
import '../services/services.dart';
import 'package:validators/validators.dart' as validator;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          Container(child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          // print('$state login page');
          final authBloc = BlocProvider.of<AuthenticationBloc>(context);
          if (state is AuthenticationAuthenticated) {
            return HomePage(
              user: state.user,
            );
          }
          if (state is AuthenticationNotAuthenticated) {
            return _AuthForm(
              islogin: true,
            );
          }
          if (state is AuthenticationNotCode) {
            return _AuthForm(islogin: false);
          }

          if (state is AuthenticationFailure) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(state.message),
                TextButton(
                  child: Text('Volver a intentar'),
                  onPressed: () {
                    authBloc.add(AppLoaded());
                  },
                )
              ],
            ));
          }
          // return splash screen
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        },
      )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final bool islogin;
  const _AuthForm({
    Key key,
    this.islogin,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    final logo = Container(
      width: 200,
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          // border: Border
          ),
      child: Image(
        image: AssetImage('assets/img/logo.png'),
      ),
    );

    final titulo = Container(
      margin: EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Text(
        'Universidad LG',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
        ),
      ),
    );

    var form = islogin ? _SignInForm() : _CodeForm();

    return Container(
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: Stack(
          alignment: Alignment.center,
          children: [
            BacgroundImage(
              image: 'assets/img/back-login.jpg',
              height: null,
            ),
            SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      logo,
                      titulo,
                      form,
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;
  bool isobscureText = true;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState.validate()) {
        _loginBloc.add(LoginInWithEmailButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            );
          }
          return Form(
            key: _key,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      decorationColor: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Correo Eletronico',
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: mainColor,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    controller: _emailController,
                    autocorrect: false,
                    validator: (String value) {
                      if (validator.isNull(value)) {
                        return '*Campo Requerido';
                      } else if (!validator.isEmail(value)) {
                        return 'Ingresa con correo electronico valido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      decorationColor: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: mainColor,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor)),
                      icon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon((isobscureText)
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isobscureText = !isobscureText;
                          });
                          print(isobscureText);
                        },
                        color: Colors.white,
                      ),
                    ),
                    obscureText: isobscureText,
                    controller: _passwordController,
                    validator: (String value) {
                      if (validator.isNull(value)) {
                        return '*Campo Requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CheckboxFormField(
                    initialValue: false,
                    title: InkWell(
                      child: Text('Polílicas de confidencialidad y privacidad',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onTap: () {
                        Navigator.of(context).push(_terminosRoute());
                      },
                    ),
                    validator: (bool value) {
                      if (value == false) {
                        return '*Campo Requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                        state is LoginLoading ? () {} : _onLoginButtonPressed,
                    style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text('Continuar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {Widget title,
      FormFieldSetter<bool> onSaved,
      FormFieldValidator<bool> validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                checkColor: Colors.white,
                activeColor: mainColor,
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                subtitle: state.hasError
                    ? Builder(
                        builder: (BuildContext context) => Text(
                          state.errorText,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}

Route _terminosRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => TerminosPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _CodeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __CodeForm();
}

class __CodeForm extends State<_CodeForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _codigodController = TextEditingController();
  bool _autoValidate = false;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final _codigoBloc = BlocProvider.of<LoginBloc>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    _oncodigoButtonPressed() {
      if (_key.currentState.validate()) {
        if (count > 2) {
          authBloc.add(UserLoggedOut());
          _showError('intentos maximos permitidos');
        } else {
          _codigoBloc.add(
              CodigoValidateButtonPressed(codigo: _codigodController.text));
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            _showError(state.error);
            count++;
          } else {
            setState(() {
              _autoValidate = true;
            });
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          bloc: _codigoBloc,
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              );
            }
            return Form(
              key: _key,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu Código',
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                      controller: _codigodController,
                      validator: (String value) {
                        if (validator.isNull(value)) {
                          return '*Campo Requerido';
                        } else if (!validator.isNumeric(value) &&
                            value.length != 4) {
                          return 'Ingrese un codigo  Correcto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: state is LoginLoading
                          ? () {}
                          : _oncodigoButtonPressed,
                      style: ElevatedButton.styleFrom(
                        primary: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text('Validar'),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
}
