part of 'streamingsingle_bloc.dart';

abstract class StreamingsingleEvent extends Equatable {
  const StreamingsingleEvent();

  @override
  List<Object> get props => [];
}

class GetSingleStramingEvent extends StreamingsingleEvent {
  final String user;
  final String token;
  final String nid;

  GetSingleStramingEvent({this.user, this.token, this.nid});

  @override
  List<Object> get props => [user, token, nid];
}
