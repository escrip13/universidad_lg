import 'package:flutter/material.dart';
import 'package:universidad_lg/User/bloc/bloc_user.dart';
import 'package:validators/validators.dart' as validator;
import 'input_login.dart';

class FormLogin extends StatefulWidget {
  UserBloc userBloc;
  FormLogin({Key key, this.userBloc});

  @override
  State<StatefulWidget> createState() {
    return _FormLogin();
  }
}

class _FormLogin extends State<FormLogin> {
  String correo;
  String password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onPressedValidator() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      widget.userBloc.signIn(correo: correo, password: password);
      // en caso de que si
      //  Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => Result(model: this.model)));

    } else {
      print("Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          MyTextFormFieldLogin(
            hintText: 'Correo Electronico',
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            isEmail: true,
            validator: (String value) {
              if (validator.isNull(value)) {
                return '*Campo Requerido';
              } else if (!validator.isEmail(value)) {
                return 'Ingresa con correo electronicop valido';
              }
              return null;
            },
            onSaved: (String value) {
              correo = value;
            },
          ),
          MyTextFormFieldLogin(
            hintText: 'Contraseña',
            isPassword: true,
            icon: Icon(
              Icons.security,
              color: Colors.white,
            ),
            validator: (String value) {
              if (value.length < 5) {
                return 'Logitud debe se mayor a 5 caracteres';
              }
              _formKey.currentState.save();
              return null;
            },
            onSaved: (String value) {
              password = value;
            },
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressedValidator,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}
