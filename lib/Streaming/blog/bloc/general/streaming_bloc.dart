import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Streaming/Exeption/exeption.dart';
import 'package:universidad_lg/Streaming/models/streaming_model.dart';
import 'package:universidad_lg/Streaming/services/streaming_service.dart';

part 'streaming_event.dart';
part 'streaming_state.dart';

class StreamingBloc extends Bloc<StreamingEvent, StreamingState> {
  final StreamingService service;

  StreamingBloc({this.service}) : super(StreamingInitial());

  @override
  Stream<StreamingState> mapEventToState(
    StreamingEvent event,
  ) async* {
    if (event is GetSreamingEvent) {
      yield* _getSreamingEvent(event);
    }
  }

  Stream<StreamingState> _getSreamingEvent(GetSreamingEvent event) async* {
    yield StreamingLoading();
    try {
      Streaming data =
          await service.getSteamingData(token: event.token, userid: event.user);

      yield StreamingSuccess(data);
    } on StreamingExeption catch (e) {
      yield ErrorStreaming(e.message);
    }
  }
}
