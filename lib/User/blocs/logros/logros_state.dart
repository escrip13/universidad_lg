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
