import 'user_dto.dart';

/// Request DTO for sending phone OTP.
class SendOtpRequestDto {
  const SendOtpRequestDto({required this.phone});

  final String phone;

  Map<String, dynamic> toJson() => <String, dynamic>{'phone': phone};
}

/// Response DTO for sending phone OTP.
class SendOtpResponseDto {
  const SendOtpResponseDto({
    required this.sessionId,
    required this.expiresInSeconds,
  });

  factory SendOtpResponseDto.fromJson(Map<String, dynamic> json) {
    return SendOtpResponseDto(
      sessionId: json['sessionId'] as String? ?? '',
      expiresInSeconds: json['expiresInSeconds'] as int? ?? 300,
    );
  }

  final String sessionId;
  final int expiresInSeconds;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sessionId': sessionId,
        'expiresInSeconds': expiresInSeconds,
      };
}

/// Request DTO for verifying OTP.
class VerifyOtpRequestDto {
  const VerifyOtpRequestDto({
    required this.phone,
    required this.otp,
    this.sessionId,
  });

  final String phone;
  final String otp;
  final String? sessionId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'phone': phone,
        'otp': otp,
        if (sessionId != null) 'sessionId': sessionId,
      };
}

/// Response DTO for verifying OTP.
class VerifyOtpResponseDto {
  const VerifyOtpResponseDto({
    required this.token,
    required this.user,
  });

  factory VerifyOtpResponseDto.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseDto(
      token: json['token'] as String? ?? '',
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>? ?? <String, dynamic>{}),
    );
  }

  final String token;
  final UserDto user;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
        'user': user.toJson(),
      };
}
