import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Noticias/Exeption/exeption.dart';
import 'package:universidad_lg/Noticias/models/noticias_model.dart';
import 'package:universidad_lg/Noticias/services/noticias_service.dart';

part 'noticias_event.dart';
part 'noticias_state.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  final NoticiasService service;

  NoticiasBloc({this.service}) : super(NoticiasInitial());

  @override
  Stream<NoticiasState> mapEventToState(
    NoticiasEvent event,
  ) async* {
    if (event is GetNoticiasEvent) {
      yield* _getNoticiasEvent(event);
    }
  }

  Stream<NoticiasState> _getNoticiasEvent(GetNoticiasEvent event) async* {
    yield NoticiasLoading();
    try {
      Noticias data =
          await service.getNoticiasData(token: event.token, userid: event.user);

      yield NoticiasSuccess(data);
    } on NoticiasExeption catch (e) {
      yield ErrorNoticias(e.message);
    }
  }
}
