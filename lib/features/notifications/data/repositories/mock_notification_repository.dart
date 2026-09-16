import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../mappers/notification_mapper.dart';
import '../models/notification_dto.dart';

/// Mock implementation of INotificationRepository with in-memory state.
class MockNotificationRepository implements INotificationRepository {
  MockNotificationRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig();

  final MockEngineConfig _engineConfig;
  List<NotificationEntity>? _inMemoryNotifications;

  List<NotificationEntity> _getInitialNotifications() {
    final list = MockFixtures.notificationsListJson['data']?['notifications'] as List<dynamic>? ?? [];
    return list
        .map((json) => NotificationMapper.toEntity(
              NotificationDto.fromJson(json as Map<String, dynamic>),
            ))
        .toList();
  }

  List<NotificationEntity> get _notifications {
    _inMemoryNotifications ??= _getInitialNotifications();
    return _inMemoryNotifications!;
  }

  @override
  Future<List<NotificationEntity>> getNotifications({int page = 1, int limit = 20}) async {
    await _engineConfig.simulateResponse();
    final start = (page - 1) * limit;
    if (start >= _notifications.length) return [];
    final end = (start + limit).clamp(0, _notifications.length);
    return List.unmodifiable(_notifications.sublist(start, end));
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _engineConfig.simulateResponse();
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await _engineConfig.simulateResponse();
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    await _engineConfig.simulateResponse();
    return _notifications.where((n) => !n.isRead).length;
  }
}
