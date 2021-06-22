import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Biblioteca/exeption/exeption.dart';
import 'package:universidad_lg/Biblioteca/models/biblioteca_model.dart';
import 'package:universidad_lg/Biblioteca/services/biblioteca_services.dart';

part 'biblioteca_event.dart';
part 'biblioteca_state.dart';

class BibliotecaBloc extends Bloc<BibliotecaEvent, BibliotecaState> {
  final BibliotecaService service;
  BibliotecaBloc({this.service}) : super(BibliotecaInitial());

  @override
  Stream<BibliotecaState> mapEventToState(
    BibliotecaEvent event,
  ) async* {
    if (event is GetBibliotecaEvent) {
      yield* _getBibliotecaEvent(event);
    }

    if (event is FiterBibliotecaEvent) {
      yield* _filterBibliotecaEvent(event);
    }
    if (event is CategoriaBibliotecaEvent) {
      yield* _categoriaBibliotecaEvent(event);
    }
  }

  Stream<BibliotecaState> _getBibliotecaEvent(GetBibliotecaEvent event) async* {
    yield BibliotecaLoad();

    try {
      Biblioteca data =
          await service.getBiblioteca(userid: event.user, token: event.token);
      yield BibliotecaSucess(data);
    } on BibliotecaExeption catch (e) {
      yield ErrorBiblioteca(e.message);
    }
  }

  Stream<BibliotecaState> _filterBibliotecaEvent(
      FiterBibliotecaEvent event) async* {
    // yield BibliotecaLoad();
    try {
      String filtro = event.filtro;
      yield BibliotecaChangeFilter(filtro);
    } on BibliotecaExeption catch (e) {
      yield ErrorBiblioteca(e.message);
    }
  }

  Stream<BibliotecaState> _categoriaBibliotecaEvent(
      CategoriaBibliotecaEvent event) async* {
    try {
      String categoria = event.categoria;
      yield BibliotecaChangeCategoria(categoria);
    } on BibliotecaExeption catch (e) {
      yield ErrorBiblioteca(e.message);
    }
  }
}
