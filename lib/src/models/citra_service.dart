part of 'models.dart';

class CitraService extends Equatable {
  final int id;
  final String name;

  const CitraService({
    required this.id,
    required this.name,
  });

  factory CitraService.fromJson(Map<String, dynamic> json) =>
      CitraService(
        id: json['id'],
        name: json['name'],
      );

  @override
  List<Object> get props => [id, name];
}
