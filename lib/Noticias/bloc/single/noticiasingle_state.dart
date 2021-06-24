part of 'noticiasingle_bloc.dart';

abstract class NoticiasingleState extends Equatable {
  const NoticiasingleState();

  @override
  List<Object> get props => [];
}

class NoticiasingleInitial extends NoticiasingleState {}

class NoticiasingleLoading extends NoticiasingleState {}

class NoticiasingleSuccess extends NoticiasingleState {
  final SingleNoticia data;
  NoticiasingleSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class ErrorNoticiasingle extends NoticiasingleState {
  final String message;
  ErrorNoticiasingle(this.message);

  @override
  List<Object> get props => [message];
}
