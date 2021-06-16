import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Ayuda/exeption/ayuda_exeption.dart';
import 'package:universidad_lg/Ayuda/models/ayuda_model.dart';
import 'package:universidad_lg/Ayuda/services/ayuda_service.dart';

part 'ayuda_event.dart';
part 'ayuda_state.dart';

class AyudaBloc extends Bloc<AyudaEvent, AyudaState> {
  final AyudaService service;
  AyudaBloc({this.service}) : super(AyudaInitial());

  @override
  Stream<AyudaState> mapEventToState(
    AyudaEvent event,
  ) async* {
    if (event is GetAyudaEvent) {
      yield* _getAyuda(event);
    }
  }

  Stream<AyudaState> _getAyuda(GetAyudaEvent event) async* {
    yield AyudaLoader();
    try {
      Ayuda data = await service.getAyuda(user: event.user, token: event.token);
      yield AyudaSuccess(data);
    } on AyudaExeption catch (e) {
      yield ErrorAyuda(e.mesaje);
    }
  }
}
