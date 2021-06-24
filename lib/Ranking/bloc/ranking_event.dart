part of 'ranking_bloc.dart';

abstract class RankingEvent extends Equatable {
  const RankingEvent();

  @override
  List<Object> get props => [];
}

class GetRanking extends RankingEvent {
  final String user;
  final String token;

  GetRanking(this.user, this.token);

  @override
  List<Object> get props => [user, token];
}
