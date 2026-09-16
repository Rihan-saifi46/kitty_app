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
}
