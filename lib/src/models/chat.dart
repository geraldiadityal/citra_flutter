part of 'models.dart';

class Chat extends Equatable {
  final int id;
  final int messageId;
  final int sessionChatId;
  final int userId;
  final bool? isUser;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    required this.id,
    required this.messageId,
    required this.sessionChatId,
    required this.userId,
    this.isUser,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'],
        messageId: json['message_id'],
        sessionChatId: json['session_chat_id'],
        userId: json['user_id'],
        isUser: json['type'] == 0
            ? true
            : json['type'] == 1
                ? false
                : null,
        deletedAt: (json['deleted_at'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(
                json['deleted_at'] * 1000,
              )
            : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          json['updated_at'] * 1000,
        ),
      );

  @override
  List<Object?> get props => [
        id,
        messageId,
        sessionChatId,
        userId,
        isUser,
        deletedAt,
        createdAt,
        updatedAt,
      ];
}
