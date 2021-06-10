part of 'streaming_bloc.dart';

abstract class StreamingState extends Equatable {
  const StreamingState();

  @override
  List<Object> get props => [];
}

class StreamingInitial extends StreamingState {}

class StreamingLoading extends StreamingState {}

class StreamingSuccess extends StreamingState {
  // el estado que es  intanciado  por el bloc y consultado en   pagina
  final Streaming data;

  StreamingSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class ErrorStreaming extends StreamingState {
  final String message;

  ErrorStreaming(this.message);

  @override
  List<Object> get props => [message];
}
