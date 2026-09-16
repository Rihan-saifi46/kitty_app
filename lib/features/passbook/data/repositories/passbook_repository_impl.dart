import '../../../../core/network/dio_client.dart';
import '../../domain/entities/passbook_entry_entity.dart';
import '../../domain/repositories/i_passbook_repository.dart';
import '../dtos/passbook_dto.dart';
import '../mappers/passbook_mapper.dart';

/// Remote implementation of [IPassbookRepository].
class PassbookRepositoryImpl implements IPassbookRepository {
  PassbookRepositoryImpl({required DioClient apiClient}) : _dio = apiClient;

  final DioClient _dio;

  @override
  Future<List<PassbookEntryEntity>> getPassbookEntries({
    String? membershipId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/memberships/my-dashboard');
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> list =
        data['dashboard']?['passbook'] as List<dynamic>? ?? <dynamic>[];

    return list
        .map((dynamic json) => PassbookMapper.toEntity(
            PassbookEntryDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}
