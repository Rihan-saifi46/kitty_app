import 'user_entity.dart';

/// Domain entity representing an active authenticated session.
class AuthSessionEntity {
  const AuthSessionEntity({
    required this.token,
    required this.user,
  });

  final String token;
  final UserEntity user;

  AuthSessionEntity copyWith({
    String? token,
    UserEntity? user,
  }) {
    return AuthSessionEntity(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

/// Result of sending an SMS OTP.
class SendOtpResultEntity {
  const SendOtpResultEntity({
    required this.sessionId,
    required this.expiresInSeconds,
  });

  final String sessionId;
  final int expiresInSeconds;
}
