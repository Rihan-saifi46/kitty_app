import '../../../../core/network/dio_client.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/repositories/i_receipt_repository.dart';
import '../mappers/receipt_mapper.dart';
import '../models/receipt_dto.dart';

/// Remote HTTP implementation of IReceiptRepository.
class ReceiptRepositoryImpl implements IReceiptRepository {
  ReceiptRepositoryImpl({required this.apiClient});

  final DioClient apiClient;

  @override
  Future<ReceiptEntity> getReceipt(String receiptId) async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/receipts/$receiptId');
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return ReceiptMapper.toEntity(ReceiptDto.fromJson(data));
  }

  @override
  Future<ReceiptEntity> getReceiptByTransactionId(String transactionId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/api/v1/receipts',
      queryParameters: {'transaction_id': transactionId},
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return ReceiptMapper.toEntity(ReceiptDto.fromJson(data));
  }

  @override
  Future<List<int>> downloadReceiptPdf(String receiptId) async {
    final response = await apiClient.get<List<int>>('/api/v1/receipts/$receiptId/download');
    if (response.data is List<int>) {
      return response.data!;
    }
    return [];
  }
}
