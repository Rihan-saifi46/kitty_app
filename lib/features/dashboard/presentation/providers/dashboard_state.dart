import '../../domain/entities/dashboard_summary_entity.dart';

/// Status states for Dashboard.
enum DashboardStatus {
  initial,
  loading,
  loaded,
  refreshing,
  empty,
  error,
}

/// State container for Kitty Dashboard.
class DashboardState {
  const DashboardState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  const DashboardState.initial()
      : status = DashboardStatus.initial,
        data = null,
        errorMessage = null;

  const DashboardState.loading()
      : status = DashboardStatus.loading,
        data = null,
        errorMessage = null;

  const DashboardState.loaded(this.data)
      : status = DashboardStatus.loaded,
        errorMessage = null;

  const DashboardState.refreshing(this.data)
      : status = DashboardStatus.refreshing,
        errorMessage = null;

  const DashboardState.empty()
      : status = DashboardStatus.empty,
        data = null,
        errorMessage = null;

  const DashboardState.error(String message)
      : status = DashboardStatus.error,
        data = null,
        errorMessage = message;

  final DashboardStatus status;
  final DashboardSummaryEntity? data;
  final String? errorMessage;

  bool get isInitial => status == DashboardStatus.initial;
  bool get isLoading => status == DashboardStatus.loading;
  bool get isLoaded => status == DashboardStatus.loaded;
  bool get isRefreshing => status == DashboardStatus.refreshing;
  bool get isEmpty => status == DashboardStatus.empty;
  bool get isError => status == DashboardStatus.error;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummaryEntity? data,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
