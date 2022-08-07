part of 'models.dart';

class User extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String roles;
  final String picturePath;
  final String companyName;
  final String phoneNumber;
  static String? token;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.picturePath,
    required this.companyName,
    required this.phoneNumber,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? roles,
    String? companyName,
    String? phoneNumber,
    String? picturePath,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        roles: roles ?? this.roles,
        email: email ?? this.email,
        companyName: companyName ?? this.companyName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        picturePath: picturePath ?? this.picturePath,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        roles: json['roles'],
        companyName: json['company_name'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        picturePath: json['profile_photo_path'] ?? 'assets/default_user.jpg',
      );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        roles,
        picturePath,
        companyName,
        phoneNumber,
      ];
}

class StatusPassword extends Equatable {
  final String message;
  final String data;
  final int code;

  StatusPassword(
      {required this.message, required this.data, required this.code});

  @override
  List<Object> get props => [message, data, code];
}
