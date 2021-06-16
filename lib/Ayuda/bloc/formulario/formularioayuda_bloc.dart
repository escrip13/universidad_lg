import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Ayuda/bloc/ayuda_bloc.dart';
import 'package:universidad_lg/Ayuda/services/form_ayuda_service.dart';

part 'formularioayuda_event.dart';
part 'formularioayuda_state.dart';

class FormularioayudaBloc
    extends Bloc<FormularioayudaEvent, FormularioayudaState> {
  final FormAyudaService service;
  FormularioayudaBloc(this.service) : super(FormularioayudaInitial());

  @override
  Stream<FormularioayudaState> mapEventToState(
    FormularioayudaEvent event,
  ) async* {
    if (event is SendFormularioAyudaEvent) {
      yield* _sendFormularioAyuda(event);
    }
  }

  Stream<FormularioayudaState> _sendFormularioAyuda(
      SendFormularioAyudaEvent event) async* {
    yield FormularioayudaLoad();

    try {
      String message = await service.sendFormAyuda(
          user: event.user,
          token: event.token,
          tema: event.tema,
          pregunta: event.pregunta);
      yield FormularioayudaSuccess(message);
    } on ErrorAyuda catch (e) {
      yield FormularioayudaError(e.message);
    }
  }
}
