import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Ayuda/bloc/formulario/formularioayuda_bloc.dart';
import 'package:universidad_lg/Ayuda/services/form_ayuda_service.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:validators/validators.dart' as validator;

import '../../constants.dart';

class AyudaFormPage extends StatelessWidget {
  final User user;

  const AyudaFormPage({Key key, @required this.user}) : super(key: key);
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
  final GlobalKey<FormFieldState> _keySelect = GlobalKey<FormFieldState>();

  final _preguntaController = TextEditingController();
  bool _autoValidate = false;
  String dropdownValue;

  List<Map> values = [
    {'label': 'General', 'value': '28'},
    {'label': 'Lavadoras', 'value': '14'},
    {'label': 'Microondas', 'value': '19'},
    {'label': 'Televisores', 'value': '10'},
  ];

  @override
  Widget build(BuildContext context) {
    _oncodigoButtonPressed() {
      if (_key.currentState.validate()) {
        final formBlock = BlocProvider.of<FormularioayudaBloc>(context);
        formBlock.add(SendFormularioAyudaEvent(
          user: widget.user.userId,
          token: widget.user.token,
          tema: dropdownValue,
          pregunta: _preguntaController.text,
        ));
        _key.currentState.reset();
        _keySelect.currentState.reset();
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    // TODO: implement build
    return BlocListener<FormularioayudaBloc, FormularioayudaState>(
      listener: (context, state) {
        if (state is FormularioayudaSuccess) {
          _showResponse(state.message);
        }
        if (state is FormularioayudaError) {
          _showResponse(state.message);
        }
      },
      child: Container(
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

            return SingleChildScrollView(
              child: Form(
                key: _key,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                        key: _keySelect,
                        value: dropdownValue,
                        hint: Text(
                          'Temas',
                        ),
                        validator: (dynamic value) {
                          if (validator.isNull(value)) {
                            return '*Campo Requerido';
                          }
                          return null;
                        },
                        isExpanded: false,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mainColor,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: mainColor))),
                        onChanged: (dynamic newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: values.map((map) {
                          return DropdownMenuItem<String>(
                            child: Text(map['label']),
                            value: map['value'],
                          );
                        }).toList()),
                    SizedBox(
                      height: 20,
                    ),
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
              ),
            );
          },
        ),
      ),
    );
  }

  void _showResponse(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: mainColor,
      ),
    );
  }
}
