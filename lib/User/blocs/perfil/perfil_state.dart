part of 'perfil_bloc.dart';

abstract class PerfilState extends Equatable {
  const PerfilState();

  @override
  List<Object> get props => [];
}

class PerfilInitial extends PerfilState {}

class PerfilLoad extends PerfilState {}

class PerfilSuccess extends PerfilState {
  final Perfil data;

  PerfilSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class ChangeImage extends PerfilState {
  final String path;

  ChangeImage(this.path);
  @override
  List<Object> get props => [path];
}

class PerfilSend extends PerfilState {
  final message;

  PerfilSend(this.message);

  @override
  List<Object> get props => [message];
}

class ErrorPerfil extends PerfilState {
  final message;

  ErrorPerfil(this.message);

  @override
  List<Object> get props => [message];
}
