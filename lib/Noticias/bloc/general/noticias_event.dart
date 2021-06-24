part of 'noticias_bloc.dart';

abstract class NoticiasEvent extends Equatable {
  const NoticiasEvent();

  @override
  List<Object> get props => [];
}

class GetNoticiasEvent extends NoticiasEvent {
  final String user;
  final String token;

  GetNoticiasEvent({this.user, this.token});
  @override
  List<Object> get props => [user, token];
}
