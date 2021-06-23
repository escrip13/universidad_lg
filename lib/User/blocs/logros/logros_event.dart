part of 'logros_bloc.dart';

abstract class LogrosEvent extends Equatable {
  const LogrosEvent();

  @override
  List<Object> get props => [];
}

class GetLogrosEvent extends LogrosEvent {
  final String user;
  final String token;

  GetLogrosEvent(this.user, this.token);

  @override
  List<Object> get props => [user, token];
}

class SearchLogrosEvent extends LogrosEvent {
  final String titulo;
  SearchLogrosEvent(this.titulo);
  @override
  List<Object> get props => [titulo];
}
