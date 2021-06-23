part of 'perfil_bloc.dart';

abstract class PerfilEvent extends Equatable {
  const PerfilEvent();

  @override
  List<Object> get props => [];
}

class GetPerfilEvent extends PerfilEvent {
  final String user;
  final String token;

  GetPerfilEvent({this.user, this.token});
  @override
  List<Object> get props => [];
}

class SetImagePerfilEvent extends PerfilEvent {
  final String path;

  SetImagePerfilEvent(this.path);

  @override
  List<Object> get props => [path];
}

class SendPerfilEvent extends PerfilEvent {
  final String user;
  final String token;
  final String documento;
  final String celular;
  final String imagen;

  SendPerfilEvent(
      {this.user, this.token, this.documento, this.celular, this.imagen});
  @override
  List<Object> get props => [documento, celular, imagen];
}
