import '../../../../core/network/dio_client.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../mappers/notification_mapper.dart';
import '../models/notification_dto.dart';

/// Remote HTTP implementation of INotificationRepository.
class NotificationRepositoryImpl implements INotificationRepository {
  NotificationRepositoryImpl({required this.apiClient});

  final DioClient apiClient;

  @override
  Future<List<NotificationEntity>> getNotifications({int page = 1, int limit = 20}) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/api/v1/notifications',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data
        .map((dynamic json) => NotificationMapper.toEntity(
              NotificationDto.fromJson(json as Map<String, dynamic>),
            ))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await apiClient.patch<Map<String, dynamic>>('/api/v1/notifications/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await apiClient.post<Map<String, dynamic>>('/api/v1/notifications/read-all');
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/notifications/unread-count');
    return (response.data?['data']?['count'] as num?)?.toInt() ?? 0;
  }
}
