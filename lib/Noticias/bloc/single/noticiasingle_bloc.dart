import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Noticias/Exeption/exeption.dart';
import 'package:universidad_lg/Noticias/models/noticias_single_model.dart';
import 'package:universidad_lg/Noticias/services/noticias_single_service.dart';

part 'noticiasingle_event.dart';
part 'noticiasingle_state.dart';

class NoticiasingleBloc extends Bloc<NoticiasingleEvent, NoticiasingleState> {
  final ServiceNoticiasSingle servive;
  NoticiasingleBloc({this.servive}) : super(NoticiasingleInitial());

  @override
  Stream<NoticiasingleState> mapEventToState(
    NoticiasingleEvent event,
  ) async* {
    if (event is GetSingleNoticiaEvent) {
      yield* _getSingleNoticiaEvent(event);
    }
  }

  Stream<NoticiasingleState> _getSingleNoticiaEvent(
      GetSingleNoticiaEvent event) async* {
    yield NoticiasingleLoading();
    try {
      SingleNoticia data = await servive.getSteamingSingleData(
          userid: event.user, token: event.token, nid: event.nid);
      yield NoticiasingleSuccess(data);
    } on NoticiasExeption catch (e) {
      yield ErrorNoticiasingle(e.message);
    }
  }
}
