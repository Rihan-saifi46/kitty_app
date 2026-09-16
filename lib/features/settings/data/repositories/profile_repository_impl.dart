import '../../../../core/network/dio_client.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../mappers/profile_mapper.dart';
import '../models/profile_dto.dart';

/// Remote HTTP implementation of IProfileRepository.
class ProfileRepositoryImpl implements IProfileRepository {
  ProfileRepositoryImpl({required this.apiClient});

  final DioClient apiClient;

  @override
  Future<ProfileEntity> getProfile() async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/users/profile');
    final data = response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return ProfileMapper.toEntity(ProfileDto.fromJson(data));
  }

  @override
  Future<ProfileEntity> updateProfile({
    String? name,
    String? email,
    String? avatarUrl,
  }) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/api/v1/users/profile',
      data: <String, dynamic>{
        'name': ?name,
        'email': ?email,
        'avatar_url': ?avatarUrl,
      },
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return ProfileMapper.toEntity(ProfileDto.fromJson(data));
  }

  @override
  Future<UserPreferencesEntity> updatePreferences(UserPreferencesEntity preferences) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/api/v1/users/preferences',
      data: ProfileMapper.toPreferencesDto(preferences).toJson(),
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return ProfileMapper.toPreferencesEntity(UserPreferencesDto.fromJson(data));
  }
}
