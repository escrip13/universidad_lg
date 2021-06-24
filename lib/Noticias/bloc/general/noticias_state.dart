part of 'noticias_bloc.dart';

abstract class NoticiasState extends Equatable {
  const NoticiasState();

  @override
  List<Object> get props => [];
}

class NoticiasInitial extends NoticiasState {}

class NoticiasLoading extends NoticiasState {}

class NoticiasSuccess extends NoticiasState {
  // el estado que es  intanciado  por el bloc y consultado en   pagina
  final Noticias data;

  NoticiasSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class ErrorNoticias extends NoticiasState {
  final String message;

  ErrorNoticias(this.message);

  @override
  List<Object> get props => [message];
}
