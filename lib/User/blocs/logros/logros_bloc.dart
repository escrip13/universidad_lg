import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/User/models/logros.dart';

part 'logros_event.dart';
part 'logros_state.dart';

class LogrosBloc extends Bloc<LogrosEvent, LogrosState> {
  LogrosBloc() : super(LogrosInitial());

  @override
  Stream<LogrosState> mapEventToState(
    LogrosEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
