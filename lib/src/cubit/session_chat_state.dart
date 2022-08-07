part of 'session_chat_cubit.dart';

abstract class SessionChatState extends Equatable {
  const SessionChatState();
}

class SessionChatInitial extends SessionChatState {
  @override
  List<Object> get props => [];
}

class SessionChatLoading extends SessionChatState {
  @override
  List<Object> get props => [];
}

class SessionChatLoaded extends SessionChatState {
  final List<SessionChat> sessionChat;

  SessionChatLoaded(this.sessionChat);

  @override
  List<Object> get props => [sessionChat];
}

class SessionChatFailed extends SessionChatState {
  final String message;

  SessionChatFailed(this.message);

  @override
  List<Object> get props => [message];
}
