import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:universidad_lg/Ranking/exeption/ranking_exeption.dart';
import 'package:universidad_lg/Ranking/models/ranking_model.dart';
import 'package:universidad_lg/Ranking/services/ranking_service.dart';

part 'ranking_event.dart';
part 'ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final RankingService service;
  RankingBloc({this.service}) : super(RankingInitial());

  @override
  Stream<RankingState> mapEventToState(
    RankingEvent event,
  ) async* {
    if (event is GetRanking) {
      yield* _getRanking(event);
    }
  }

  Stream<RankingState> _getRanking(GetRanking event) async* {
    yield RankingLoad();
    try {
      final data =
          await service.getRankingService(uid: event.user, token: event.token);
      yield RankingSuccess(data);
    } on RankingExeption catch (e) {
      yield ErrorRanking(e.message);
    }
  }
}
