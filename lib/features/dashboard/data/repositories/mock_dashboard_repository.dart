import '../../../../core/enums/app_enums.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/i_dashboard_repository.dart';
import '../dtos/dashboard_dto.dart';
import '../mappers/dashboard_mapper.dart';

/// Mock implementation of [IDashboardRepository].
class MockDashboardRepository implements IDashboardRepository {
  MockDashboardRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig.instance;

  final MockEngineConfig _engineConfig;
  bool _hasActiveScheme = true;
  MembershipStatusEnum _status = MembershipStatusEnum.active;
  bool _shouldThrow = false;

  /// Allows toggling empty dashboard state for testing empty states.
  void setHasActiveScheme(bool hasActive) {
    _hasActiveScheme = hasActive;
  }

  /// Sets mock status (e.g. active, preJoin, completed).
  void setStatus(MembershipStatusEnum status) {
    _status = status;
  }

  /// Forces throwing an exception for testing error handling.
  void setShouldThrow(bool shouldThrow) {
    _shouldThrow = shouldThrow;
  }

  @override
  Future<DashboardSummaryEntity> getMyDashboard() async {
    await _engineConfig.simulate();

    if (_shouldThrow) {
      throw const NetworkException('Failed to retrieve kitty dashboard summary.');
    }

    if (!_hasActiveScheme) {
      return const DashboardSummaryEntity(hasActiveScheme: false);
    }

    final DashboardSummaryResponseDto dto =
        DashboardSummaryResponseDto.fromJson(
      MockFixtures.dashboardActiveSuvarnaJson['data'] as Map<String, dynamic>,
    );

    final DashboardSummaryEntity baseEntity = DashboardMapper.toEntity(dto);
    if (_status != MembershipStatusEnum.active) {
      return DashboardSummaryEntity(
        hasActiveScheme: baseEntity.hasActiveScheme,
        membershipId: baseEntity.membershipId,
        chitToken: baseEntity.chitToken,
        schemeName: baseEntity.schemeName,
        targetAmount: baseEntity.targetAmount,
        customMonthlyEmi: baseEntity.customMonthlyEmi,
        totalMonths: baseEntity.totalMonths,
        monthsPaid: _status == MembershipStatusEnum.completed ? baseEntity.totalMonths : baseEntity.monthsPaid,
        totalPaidAmount: _status == MembershipStatusEnum.completed ? baseEntity.targetAmount : baseEntity.totalPaidAmount,
        remainingAmount: _status == MembershipStatusEnum.completed ? 0 : baseEntity.remainingAmount,
        accumulatedGoldGrams: baseEntity.accumulatedGoldGrams,
        currentValuation: baseEntity.currentValuation,
        valuationGainPct: baseEntity.valuationGainPct,
        nextInstallment: _status == MembershipStatusEnum.completed ? null : baseEntity.nextInstallment,
        passbook: baseEntity.passbook,
        status: _status,
      );
    }

    return baseEntity;
  }
}
