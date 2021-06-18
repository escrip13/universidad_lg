part of 'formularioayuda_bloc.dart';

abstract class FormularioayudaEvent extends Equatable {
  const FormularioayudaEvent();

  @override
  List<Object> get props => [];
}

class SendFormularioAyudaEvent extends FormularioayudaEvent {
  final String tema;
  final String pregunta;
  final String user;
  final String token;

  SendFormularioAyudaEvent({this.user, this.token, this.tema, this.pregunta});
  @override
  List<Object> get props => [tema, pregunta, user, token];
}
