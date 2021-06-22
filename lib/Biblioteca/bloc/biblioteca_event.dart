part of 'biblioteca_bloc.dart';

abstract class BibliotecaEvent extends Equatable {
  const BibliotecaEvent();

  @override
  List<Object> get props => [];
}

class GetBibliotecaEvent extends BibliotecaEvent {
  final String user;
  final String token;

  GetBibliotecaEvent({this.user, this.token});
  @override
  List<Object> get props => [user, token];
}

class FiterBibliotecaEvent extends BibliotecaEvent {
  final String filtro;

  FiterBibliotecaEvent({this.filtro});
  @override
  List<Object> get props => [filtro];
}

class CategoriaBibliotecaEvent extends BibliotecaEvent {
  final String categoria;

  CategoriaBibliotecaEvent({this.categoria});
  @override
  List<Object> get props => [categoria];
}
