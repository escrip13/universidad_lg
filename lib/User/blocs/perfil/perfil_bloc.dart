import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/User/exceptions/perfil_exception.dart';
import 'package:universidad_lg/User/models/perfil.dart';

import 'package:universidad_lg/User/services/perfil_service.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  final PerfilService service;
  PerfilBloc({this.service}) : super(PerfilInitial());

  @override
  Stream<PerfilState> mapEventToState(
    PerfilEvent event,
  ) async* {
    if (event is GetPerfilEvent) {
      yield* _getPerfil(event);
    }
    if (event is SetImagePerfilEvent) {
      yield* _setImagePerfil(event);
    }
    if (event is SendPerfilEvent) {
      yield* _sendPerfin(event);
    }
  }

  Stream<PerfilState> _getPerfil(GetPerfilEvent event) async* {
    yield PerfilLoad();

    try {
      Perfil data = await service.getPerfil(event.user, event.token);

      yield PerfilSuccess(data);
    } on PerfinException catch (e) {
      yield ErrorPerfil(e.message);
    }
  }

  Stream<PerfilState> _setImagePerfil(SetImagePerfilEvent event) async* {
    yield ChangeImage(event.path);
  }

  Stream<PerfilState> _sendPerfin(SendPerfilEvent event) async* {
    yield PerfilLoad();

    try {
      String message = await service.sentPerfil(event.user, event.token,
          event.documento, event.celular, event.imagen);

      yield PerfilSend(message);
      // Perfil data = await service.getPerfil(event.user, event.token);
      // yield PerfilSuccess(data);
    } on PerfinException catch (e) {
      yield ErrorPerfil(e.message);
    }

    try {
      Perfil data = await service.getPerfil(event.user, event.token);

      yield PerfilSuccess(data);
    } on PerfinException catch (e) {
      yield ErrorPerfil(e.message);
    }
  }
}
