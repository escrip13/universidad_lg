part of 'biblioteca_bloc.dart';

abstract class BibliotecaState extends Equatable {
  const BibliotecaState();

  @override
  List<Object> get props => [];
}

class BibliotecaInitial extends BibliotecaState {}

class BibliotecaLoad extends BibliotecaState {}

class BibliotecaSucess extends BibliotecaState {
  final Biblioteca data;
  BibliotecaSucess(this.data);
  @override
  List<Object> get props => [data];
}

class BibliotecaChangeFilter extends BibliotecaState {
  final String filtro;
  BibliotecaChangeFilter(this.filtro);
  @override
  List<Object> get props => [filtro];
}

class BibliotecaChangeCategoria extends BibliotecaState {
  final String categoria;
  BibliotecaChangeCategoria(this.categoria);
  @override
  List<Object> get props => [categoria];
}

class ErrorBiblioteca extends BibliotecaState {
  final String message;

  ErrorBiblioteca(this.message);

  @override
  List<Object> get props => [message];
}
