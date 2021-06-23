import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/User/exceptions/logros_exception.dart';
import 'package:universidad_lg/User/models/logros.dart';
import 'package:universidad_lg/User/services/logros_service.dart';

part 'logros_event.dart';
part 'logros_state.dart';

class LogrosBloc extends Bloc<LogrosEvent, LogrosState> {
  final LogrosService service;
  LogrosBloc({this.service}) : super(LogrosInitial());

  @override
  Stream<LogrosState> mapEventToState(
    LogrosEvent event,
  ) async* {
    if (event is GetLogrosEvent) {
      yield* _getLogros(event);
    }
    if (event is SearchLogrosEvent) {
      yield* _searchLogros(event);
    }
  }

  Stream<LogrosState> _getLogros(GetLogrosEvent event) async* {
    yield LogrosLoad();
    try {
      final Logros data = await service.getLogros(event.user, event.token);
      yield LogrosSuccess(data);
    } on LogrosException catch (e) {
      yield ErrorLogros(e.message);
    }
  }

  Stream<LogrosState> _searchLogros(SearchLogrosEvent event) async* {
    yield LogrosSearch(event.titulo);
  }
}
