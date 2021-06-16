part of 'ayuda_bloc.dart';

abstract class AyudaState extends Equatable {
  const AyudaState();

  @override
  List<Object> get props => [];
}

class AyudaInitial extends AyudaState {}

class AyudaLoader extends AyudaState {
  @override
  List<Object> get props => [];
}

class AyudaSuccess extends AyudaState {
  final Ayuda data;

  AyudaSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class ErrorAyuda extends AyudaState {
  final String message;

  ErrorAyuda(this.message);

  @override
  List<Object> get props => [message];
}
