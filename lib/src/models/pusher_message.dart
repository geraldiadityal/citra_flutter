part of 'models.dart';

class PusherMessage {
  final String content;
  final Chat chat;

  PusherMessage({
    required this.content,
    required this.chat,
  });

  factory PusherMessage.fromPusherJson(Map<String, dynamic> json) =>
      PusherMessage(
        content: json['content'],
        chat: Chat.fromJson(json['chat']),
      );

  factory PusherMessage.fromFetchJson(Map<String, dynamic> json) =>
      PusherMessage(
        content: json['message']['content'],
        chat: Chat.fromJson(json),
      );
}
