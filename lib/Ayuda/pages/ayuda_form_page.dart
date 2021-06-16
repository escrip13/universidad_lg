import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Ayuda/bloc/formulario/formularioayuda_bloc.dart';
import 'package:universidad_lg/Ayuda/services/form_ayuda_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:validators/validators.dart' as validator;

import '../../constants.dart';

class AyudaFormPage extends StatelessWidget {
  final User user;

  const AyudaFormPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FORMULA TU RESPUESTA',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: mainColor,
      ),
      body: BlocProvider<FormularioayudaBloc>(
        create: (context) => FormularioayudaBloc(IsformAyuadaService()),
        child: _ContentFormAyuda(
          user: user,
        ),
      ),
    );
  }
}

class _ContentFormAyuda extends StatefulWidget {
  final User user;

  const _ContentFormAyuda({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => __ContentFormAyuda();
}

class __ContentFormAyuda extends State<_ContentFormAyuda> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final _preguntaController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    _oncodigoButtonPressed() {
      if (_key.currentState.validate()) {
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: BlocBuilder<FormularioayudaBloc, FormularioayudaState>(
        builder: (context, state) {
          if (state is FormularioayudaLoad) {
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
            child: Column(
              children: [
                TextFormField(
                  maxLines: 8,
                  controller: _preguntaController,
                  decoration: InputDecoration(
                    hintText: 'Pregunta',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: mainColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondColor),
                    ),
                  ),
                  autocorrect: false,
                  validator: (String value) {
                    if (validator.isNull(value)) {
                      return '*Campo Requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: _oncodigoButtonPressed,
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text('ENVIAR'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
