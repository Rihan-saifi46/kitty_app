import '../../../../core/enums/app_enums.dart';
import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/payment_order_entity.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../dtos/payment_dto.dart';
import '../mappers/payment_mapper.dart';

/// Mock implementation of [IPaymentRepository] with state transition polling support.
class MockPaymentRepository implements IPaymentRepository {
  MockPaymentRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig.instance;

  final MockEngineConfig _engineConfig;
  final Map<String, int> _pollCounts = <String, int>{};
  PaymentStatusEnum _forcedFinalStatus = PaymentStatusEnum.success;
  int _requiredPollsBeforeSuccess = 2;

  /// Configures polling behavior for testing.
  void configurePolling({
    PaymentStatusEnum finalStatus = PaymentStatusEnum.success,
    int requiredPolls = 2,
  }) {
    _forcedFinalStatus = finalStatus;
    _requiredPollsBeforeSuccess = requiredPolls;
  }

  @override
  Future<PaymentOrderEntity> initiatePayment({
    required String membershipId,
    required int monthFor,
    PaymentMethodEnum paymentMethod = PaymentMethodEnum.online,
  }) async {
    await _engineConfig.simulate();

    final PaymentInitiateResponseDto dto =
        PaymentInitiateResponseDto.fromJson(
      MockFixtures.paymentInitiateSuccessJson['data'] as Map<String, dynamic>,
    );

    _pollCounts[dto.orderId] = 0;

    return PaymentMapper.toOrderEntity(dto);
  }

  @override
  Future<PaymentStatusEntity> getPaymentStatus(String orderId) async {
    await _engineConfig.simulate();

    final int currentPoll = (_pollCounts[orderId] ?? 0) + 1;
    _pollCounts[orderId] = currentPoll;

    // Simulate PENDING on initial polls, transitioning to final status
    if (currentPoll <= _requiredPollsBeforeSuccess) {
      final PaymentStatusResponseDto pendingDto =
          PaymentStatusResponseDto.fromJson(
        MockFixtures.paymentStatusPendingJson['data'] as Map<String, dynamic>,
      );
      return PaymentMapper.toStatusEntity(pendingDto);
    }

    if (_forcedFinalStatus == PaymentStatusEnum.failed) {
      final PaymentStatusResponseDto failedDto =
          PaymentStatusResponseDto.fromJson(
        MockFixtures.paymentStatusFailedJson['data'] as Map<String, dynamic>,
      );
      return PaymentMapper.toStatusEntity(failedDto);
    }

    final PaymentStatusResponseDto successDto =
        PaymentStatusResponseDto.fromJson(
      MockFixtures.paymentStatusSuccessJson['data'] as Map<String, dynamic>,
    );
    return PaymentMapper.toStatusEntity(successDto);
  }
}
