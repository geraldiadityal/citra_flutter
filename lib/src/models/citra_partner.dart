part of 'models.dart';

class CitraPartner extends Equatable {
  final int id;
  final User? user;
  final CitraService service;
  final int price;
  final DateTime active_at;

  const CitraPartner({
    required this.id,
    this.user,
    required this.service,
    required this.price,
    required this.active_at,
  });

  factory CitraPartner.fromJson(Map<String, dynamic> json) => CitraPartner(
        id: json['id'],
        user: User.fromJson(json['user']),
        service: CitraService.fromJson(json['service']),
        price: json['price'],
        active_at: DateTime.fromMillisecondsSinceEpoch(
          json['active_at'] * 1000,
        ),
      );

  @override
  List<Object> get props => [id, service, price];
}
