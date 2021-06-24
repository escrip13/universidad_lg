part of 'ranking_bloc.dart';

abstract class RankingState extends Equatable {
  const RankingState();

  @override
  List<Object> get props => [];
}

class RankingInitial extends RankingState {}

class RankingLoad extends RankingState {}

class RankingSuccess extends RankingState {
  final Ranking data;

  RankingSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class ErrorRanking extends RankingState {
  final String message;

  ErrorRanking(this.message);
  @override
  List<Object> get props => [message];
}
