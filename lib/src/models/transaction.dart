part of 'models.dart';

enum TransactionStatus { success, pending, expire, finish }

class Transaction extends Equatable {
  final int id;
  final int partner_id;
  final int? sessionChatId;
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
