import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetHomeContent extends HomeEvent {
  final String uid;
  final String token;

  GetHomeContent({@required this.uid, @required this.token});

  @override
  List<Object> get props => [uid, token];
}
