import 'package:movie_vault/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.userId, required super.email});

  factory AuthSessionModel.fromJson(Map<dynamic, dynamic> json) {
    return AuthSessionModel(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  factory AuthSessionModel.fromFirebase({
    required String userId,
    required String email,
  }) {
    return AuthSessionModel(userId: userId, email: email);
  }

  Map<String, String> toJson() => {'userId': userId, 'email': email};
}
