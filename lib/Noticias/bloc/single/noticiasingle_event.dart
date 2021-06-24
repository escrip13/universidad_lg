part of 'noticiasingle_bloc.dart';

abstract class NoticiasingleEvent extends Equatable {
  const NoticiasingleEvent();

  @override
  List<Object> get props => [];
}

class GetSingleNoticiaEvent extends NoticiasingleEvent {
  final String user;
  final String token;
  final String nid;

  GetSingleNoticiaEvent({this.user, this.token, this.nid});

  @override
  List<Object> get props => [user, token, nid];
}
