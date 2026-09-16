import '../../../../core/network/dio_client.dart';
import '../../domain/entities/kyc_entity.dart';
import '../../domain/repositories/i_kyc_repository.dart';
import '../dtos/kyc_dto.dart';
import '../mappers/kyc_mapper.dart';

/// Remote implementation of [IKycRepository] (Ready for Phase 16 integration).
class KycRepositoryImpl implements IKycRepository {
  KycRepositoryImpl({required DioClient apiClient}) : _dio = apiClient;

  final DioClient _dio;

  @override
  Future<KycResultEntity> submitKyc(KycSubmissionEntity submission) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/users/kyc',
      data: KycSubmitRequestDto(
        documentType: submission.documentType.toJson(),
        documentNumber: submission.documentNumber,
        consentAgreed: submission.consentAgreed,
      ).toJson(),
    );

    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return KycMapper.toEntity(KycSubmitResponseDto.fromJson(data));
  }

  @override
  Future<KycResultEntity> getKycStatus() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/users/kyc/status');
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return KycMapper.toEntity(KycSubmitResponseDto.fromJson(data));
  }
}
