import '../../../../core/network/dio_client.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/entities/scheme_entity.dart';
import '../../domain/repositories/i_offer_repository.dart';
import '../../domain/repositories/i_scheme_repository.dart';
import '../dtos/offer_dto.dart';
import '../dtos/scheme_dto.dart';
import '../mappers/offer_mapper.dart';
import '../mappers/scheme_mapper.dart';

/// Remote implementation of [ISchemeRepository] and [IOfferRepository].
class SchemeRepositoryImpl implements ISchemeRepository, IOfferRepository {
  SchemeRepositoryImpl({required DioClient apiClient}) : _dio = apiClient;

  final DioClient _dio;

  @override
  Future<List<SchemeEntity>> getActiveSchemes({int? durationFilter}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/schemes/active',
      queryParameters: durationFilter != null
          ? <String, dynamic>{'duration': durationFilter}
          : null,
    );

    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> list = data['schemes'] as List<dynamic>? ?? <dynamic>[];

    return list
        .map((dynamic json) =>
            SchemeMapper.toEntity(SchemeDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  @override
  Future<SchemeEntity> getSchemeById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/schemes/$id');
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return SchemeMapper.toEntity(SchemeDto.fromJson(data));
  }

  @override
  Future<List<OfferEntity>> getActiveOffers() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/offers');
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> list = data['offers'] as List<dynamic>? ?? <dynamic>[];

    return list
        .map((dynamic json) =>
            OfferMapper.toEntity(OfferDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}
