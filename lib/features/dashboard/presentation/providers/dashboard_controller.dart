import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/i_dashboard_repository.dart';
import 'dashboard_state.dart';

/// Riverpod provider for [DashboardController].
final NotifierProvider<DashboardController, DashboardState> dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardState>(DashboardController.new);

/// Controller managing active scheme dashboard metrics, loading, refresh, and error handling.
class DashboardController extends Notifier<DashboardState> {
  late IDashboardRepository _dashboardRepository;

  @override
  DashboardState build() {
    _dashboardRepository = ref.watch(dashboardRepositoryProvider);

    // Trigger initial data load
    Future<void>.microtask(loadDashboard);

    return const DashboardState.loading();
  }

  /// Fetches active kitty dashboard summary from repository.
  Future<void> loadDashboard({bool refresh = false}) async {
    final DashboardSummaryEntity? cachedData = state.data;

    if (refresh && cachedData != null) {
      state = DashboardState.refreshing(cachedData);
    } else {
      state = const DashboardState.loading();
    }

    try {
      final DashboardSummaryEntity summary = await _dashboardRepository.getMyDashboard();

      if (!summary.hasActiveScheme) {
        state = const DashboardState.empty();
      } else {
        state = DashboardState.loaded(summary);
      }
    } on AppException catch (e) {
      if (refresh && cachedData != null) {
        state = DashboardState(
          status: DashboardStatus.loaded,
          data: cachedData,
          errorMessage: e.message,
        );
      } else {
        state = DashboardState.error(e.message);
      }
    } catch (_) {
      if (refresh && cachedData != null) {
        state = DashboardState(
          status: DashboardStatus.loaded,
          data: cachedData,
          errorMessage: 'Failed to refresh. Showing cached data.',
        );
      } else {
        state = const DashboardState.error(
          'Unable to load your kitty details. Please check your connection and try again.',
        );
      }
    }
  }

  /// Retries loading dashboard data.
  Future<void> retry() async {
    await loadDashboard();
  }
}
