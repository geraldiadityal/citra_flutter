part of 'models.dart';

class SessionChat {
  final int id;
  final int user1_id;
  final int user2_id;
  final DateTime expired_at;
  final DateTime created_at;
  final DateTime updated_at;
  final MessageSession? messageSession;
  final Transaction? transaction;
  final User user;
  final User dataPartner;

  SessionChat({
    required this.id,
    required this.user1_id,
    required this.user2_id,
    required this.created_at,
    required this.updated_at,
    this.messageSession,
    required this.expired_at,
    this.transaction,
    required this.user,
    required this.dataPartner,
  });

  factory SessionChat.fromJson(Map<String, dynamic> json) => SessionChat(
        id: json['id'],
        user1_id: json['user1_id'],
        user2_id: json['user2_id'],
        created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000,
        ),
        updated_at: DateTime.fromMillisecondsSinceEpoch(
          json['updated_at'] * 1000,
        ),
        messageSession: (json['messages']).length >= 1
            ? MessageSession.fromJson(json['messages'][0])
            : null,
        expired_at: DateTime.fromMillisecondsSinceEpoch(
          json['expire_at'] * 1000,
        ),
        transaction: Transaction.fromJson(
          json['transaction'],
        ),
        user: User.fromJson(
          json['user'],
        ),
        dataPartner: User.fromJson(json['partner']),
      );
}

class MessageSession {
  final int id;
  final String content;
  final DateTime created_at;
  final DateTime updated_at;

  MessageSession({
    required this.id,
    required this.content,
    required this.created_at,
    required this.updated_at,
  });

  factory MessageSession.fromJson(Map<String, dynamic> json) => MessageSession(
        id: json['id'],
        content: json['content'],
        created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000,
        ),
        updated_at: DateTime.fromMillisecondsSinceEpoch(
          json['updated_at'] * 1000,
        ),
      );
}
