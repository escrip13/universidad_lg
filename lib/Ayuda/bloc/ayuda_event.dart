part of 'ayuda_bloc.dart';

abstract class AyudaEvent extends Equatable {
  const AyudaEvent();

  @override
  List<Object> get props => [];
}

class GetAyudaEvent extends AyudaEvent {
  final user;
  final token;

  GetAyudaEvent({this.user, this.token});

  @override
  List<Object> get props => [user, token];
}
