part of 'logros_bloc.dart';

abstract class LogrosState extends Equatable {
  const LogrosState();

  @override
  List<Object> get props => [];
}

class LogrosInitial extends LogrosState {}

class LogrosLoad extends LogrosState {}

class LogrosSuccess extends LogrosState {
  final Logros data;

  LogrosSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class LogrosSearch extends LogrosState {
  final String title;

  LogrosSearch(this.title);
  @override
  List<Object> get props => [title];
}

class ErrorLogros extends LogrosState {
  final String message;

  ErrorLogros(this.message);
  @override
  List<Object> get props => [message];
}
