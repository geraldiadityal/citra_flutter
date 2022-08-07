part of 'pusher_message_cubit.dart';

abstract class PusherMessageState extends Equatable {
  const PusherMessageState();
}

class PusherMessageInitial extends PusherMessageState {
  @override
  List<Object> get props => [];
}

class PusherMessageLoading extends PusherMessageState {
  @override
  List<Object> get props => [];
}

class PusherMessageSuccess extends PusherMessageState {
  final List<PusherMessage> pusherMessage;

  PusherMessageSuccess(this.pusherMessage);

  @override
  List<Object> get props => [pusherMessage];
}

class PusherMessageFailed extends PusherMessageState {
  final String message;

  PusherMessageFailed(this.message);

  @override
  List<Object> get props => [];
}
