part of 'streaming_bloc.dart';

abstract class StreamingEvent extends Equatable {
  const StreamingEvent();

  @override
  List<Object> get props => [];
}

class GetSreamingEvent extends StreamingEvent {
  final String user;
  final String token;

  GetSreamingEvent({this.user, this.token});
  @override
  List<Object> get props => [user, token];
}
