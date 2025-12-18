import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/notification/data/model/notification_model.dart';

abstract interface class NotificationRemoteDatasource {
  Future<NotificationModel> getNotifications({int page = 1, int limit = 10});
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioClient dioClient;

  NotificationRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<NotificationModel> getNotifications(
      {int page = 1, int limit = 10}) async {
    try {
      final res = await dioClient.get(
        url:
            "${NotificationApiUrls.getAllNotifications}?page=$page&limit=$limit",
      );

      if (res.statusCode == 200) {
        final data = res.data['data'];
        return NotificationModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Failed to load notifications');
      }
    } catch (e) {
      throw ServerException(message: 'Failed to load notifications: $e');
    }
  }
}
