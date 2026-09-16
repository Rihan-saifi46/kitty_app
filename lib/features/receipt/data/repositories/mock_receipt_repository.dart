import 'dart:convert';
import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/repositories/i_receipt_repository.dart';
import '../mappers/receipt_mapper.dart';
import '../models/receipt_dto.dart';

/// Mock implementation of IReceiptRepository.
class MockReceiptRepository implements IReceiptRepository {
  MockReceiptRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig();

  final MockEngineConfig _engineConfig;

  @override
  Future<ReceiptEntity> getReceipt(String receiptId) async {
    await _engineConfig.simulateResponse();
    final data = MockFixtures.digitalReceiptJson['data'] as Map<String, dynamic>? ?? {};
    return ReceiptMapper.toEntity(ReceiptDto.fromJson(data));
  }

  @override
  Future<ReceiptEntity> getReceiptByTransactionId(String transactionId) async {
    await _engineConfig.simulateResponse();
    final data = Map<String, dynamic>.from(MockFixtures.digitalReceiptJson['data'] as Map<String, dynamic>? ?? {});
    data['transactionId'] = transactionId;
    return ReceiptMapper.toEntity(ReceiptDto.fromJson(data));
  }

  @override
  Future<List<int>> downloadReceiptPdf(String receiptId) async {
    await _engineConfig.simulateResponse();
    // Return dummy PDF header/bytes
    return utf8.encode('%PDF-1.4 Mock Receipt for $receiptId\n%%EOF');
  }
}
