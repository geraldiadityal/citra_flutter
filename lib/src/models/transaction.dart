part of 'models.dart';

enum TransactionStatus { success, pending, expire, finish }

class Transaction extends Equatable {
  final int id;
  final int partner_id;
  final int? sessionChatId;
  final Session? session;
  final User? user;
  final int total;
  final TransactionStatus status;
  final String paymentUrl;
  final DateTime dateTime;
  final DateTime? expTime;

  Transaction({
    required this.id,
    required this.partner_id,
    this.sessionChatId,
    this.session,
    required this.user,
    required this.total,
    required this.status,
    this.paymentUrl = '',
    required this.dateTime,
    this.expTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        partner_id: json['partner_id'],
        sessionChatId: json['session_chat_id'],
        session: (json['session'] != null)
            ? Session.fromJson(json['session'])
            : null,
        user: (json['user'] != null) ? User.fromJson(json['user']) : null,
        total: json['total'],
        status: (json['status'] == 'EXPIRE'
            ? TransactionStatus.expire
            : (json['status'] == 'SUCCESS')
                ? TransactionStatus.success
                : (json['status'] == 'FINISH')
                    ? TransactionStatus.finish
                    : TransactionStatus.pending),
        paymentUrl: json['payment_url'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000,
        ),
        expTime: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000,
        ).add(
          const Duration(days: 1),
        ),
      );

  Transaction copyWith({
    int? id,
    int? partner_id,
    User? user,
    int? total,
    TransactionStatus? status,
    DateTime? dateTime,
  }) {
    return Transaction(
        id: id ?? this.id,
        partner_id: partner_id ?? this.partner_id,
        user: user ?? this.user,
        total: total ?? this.total,
        status: status ?? this.status,
        dateTime: dateTime ?? this.dateTime);
  }

  @override
  List<Object?> get props => [
        id,
        partner_id,
        sessionChatId,
        user,
        total,
        status,
        paymentUrl,
        dateTime,
      ];
}

class Session extends Equatable {
  final int id;
  final int user1_id;
  final int user2_id;
  final DateTime expired_at;
  final DateTime created_at;
  final DateTime updated_at;

  Session({
    required this.id,
    required this.user1_id,
    required this.user2_id,
    required this.expired_at,
    required this.created_at,
    required this.updated_at,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        user1_id: json['user1_id'],
        user2_id: json['user2_id'],
        expired_at: DateTime.fromMillisecondsSinceEpoch(
          json['expire_at'] * 1000,
        ),
        created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'] * 1000,
        ),
        updated_at: DateTime.fromMillisecondsSinceEpoch(
          json['updated_at'] * 1000,
        ),
      );

  @override
  List<Object> get props => [
        id,
        user1_id,
        user2_id,
        expired_at,
        created_at,
        updated_at,
      ];
}
