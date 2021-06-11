part of 'streamingsingle_bloc.dart';

abstract class StreamingsingleState extends Equatable {
  const StreamingsingleState();

  @override
  List<Object> get props => [];
}

class StreamingsingleInitial extends StreamingsingleState {}

class StreamingsingleLoading extends StreamingsingleState {}

class StreamingsingleSuccess extends StreamingsingleState {
  final SingleStreaming data;
  StreamingsingleSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class ErrorStreamingsingle extends StreamingsingleState {
  final String message;
  ErrorStreamingsingle(this.message);

  @override
  List<Object> get props => [message];
}
