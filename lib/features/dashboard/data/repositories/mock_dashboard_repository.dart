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

  /// Allows toggling empty dashboard state for testing empty states.
  void setHasActiveScheme(bool hasActive) {
    _hasActiveScheme = hasActive;
  }

  @override
  Future<DashboardSummaryEntity> getMyDashboard() async {
    await _engineConfig.simulate();

    if (!_hasActiveScheme) {
      return const DashboardSummaryEntity(hasActiveScheme: false);
    }

    final DashboardSummaryResponseDto dto =
        DashboardSummaryResponseDto.fromJson(
      MockFixtures.dashboardActiveSuvarnaJson['data'] as Map<String, dynamic>,
    );

    return DashboardMapper.toEntity(dto);
  }
}
