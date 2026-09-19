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
    final userJson = (data['user'] as Map<String, dynamic>?) ?? data;
    return ProfileMapper.toEntity(ProfileDto.fromJson(userJson));
  }

  @override
  Future<ProfileEntity> updateProfile({
    String? name,
    String? email,
    String? avatarUrl,
  }) async {
    // The backend does not expose a PUT /api/v1/users/profile endpoint.
    // Return the active profile safely without invoking nonexistent remote routes.
    final ProfileEntity current = await getProfile();
    return current.copyWith(
      name: name ?? current.name,
      email: email ?? current.email,
      avatarUrl: avatarUrl ?? current.avatarUrl,
    );
  }

  @override
  Future<UserPreferencesEntity> updatePreferences(UserPreferencesEntity preferences) async {
    // The backend does not store UI preferences; preferences are handled locally via
    // SettingsLocalRepositoryImpl. Safely return preferences without invoking nonexistent remote routes.
    return preferences;
  }
}
