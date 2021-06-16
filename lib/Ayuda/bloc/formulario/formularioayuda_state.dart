part of 'formularioayuda_bloc.dart';

abstract class FormularioayudaState extends Equatable {
  const FormularioayudaState();

  @override
  List<Object> get props => [];
}

class FormularioayudaInitial extends FormularioayudaState {}

class FormularioayudaLoad extends FormularioayudaState {}

class FormularioayudaSuccess extends FormularioayudaState {
  final String message;

  FormularioayudaSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class FormularioayudaError extends FormularioayudaState {
  final String message;

  FormularioayudaError(this.message);
  @override
  List<Object> get props => [message];
}
