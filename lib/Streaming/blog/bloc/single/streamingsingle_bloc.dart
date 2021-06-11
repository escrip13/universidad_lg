import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Streaming/Exeption/exeption.dart';
import 'package:universidad_lg/Streaming/models/streaming_single_model.dart';
import 'package:universidad_lg/Streaming/services/streaming_single_service.dart';

part 'streamingsingle_event.dart';
part 'streamingsingle_state.dart';

class StreamingsingleBloc
    extends Bloc<StreamingsingleEvent, StreamingsingleState> {
  final ServiceStreamingSingle servive;
  StreamingsingleBloc({this.servive}) : super(StreamingsingleInitial());

  @override
  Stream<StreamingsingleState> mapEventToState(
    StreamingsingleEvent event,
  ) async* {
    if (event is GetSingleStramingEvent) {
      yield* _getSingleSreamingEvent(event);
    }
  }

  Stream<StreamingsingleState> _getSingleSreamingEvent(
      GetSingleStramingEvent event) async* {
    yield StreamingsingleLoading();
    try {
      SingleStreaming data = await servive.getSteamingSingleData(
          userid: event.user, token: event.token, nid: event.nid);
      yield StreamingsingleSuccess(data);
    } on StreamingExeption catch (e) {
      yield ErrorStreamingsingle(e.message);
    }
  }
}
