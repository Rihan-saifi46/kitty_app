import '../../../../core/enums/app_enums.dart';
import 'kyc_info_entity.dart';

/// Pure domain entity representing an authenticated Kitty App patron.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.email,
    this.tier = 'Tier 1 Verified Member',
    this.kyc = const KycInfoEntity(
      isVerified: false,
      status: KycStatusEnum.notSubmitted,
    ),
    required this.createdAt,
    this.nomineeName,
    this.nomineeRelationship,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserRoleEnum role;
  final String tier;
  final KycInfoEntity kyc;
  final DateTime createdAt;
  final String? nomineeName;
  final String? nomineeRelationship;

  UserEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserRoleEnum? role,
    String? tier,
    KycInfoEntity? kyc,
    DateTime? createdAt,
    String? nomineeName,
    String? nomineeRelationship,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      tier: tier ?? this.tier,
      kyc: kyc ?? this.kyc,
      createdAt: createdAt ?? this.createdAt,
      nomineeName: nomineeName ?? this.nomineeName,
      nomineeRelationship: nomineeRelationship ?? this.nomineeRelationship,
    );
  }
}
