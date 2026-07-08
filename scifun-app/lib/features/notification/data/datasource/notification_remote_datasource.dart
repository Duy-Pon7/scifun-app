import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/notification/data/model/notification_model.dart';

abstract interface class NotificationRemoteDatasource {
  Future<NotificationModel> getNotifications({int page = 1, int limit = 10});

  Future<bool> markAsRead(String id);

  Future<bool> markAllAsRead();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioClient dioClient;

  NotificationRemoteDatasourceImpl({required this.dioClient});

  bool _checkSuccess(dynamic data) {
    final message = (data?['message'] ?? data ?? '').toString().toLowerCase();
    return message.contains('thanh cong') ||
        message.contains('thanh cong.') ||
        message.contains('thành công');
  }

  @override
  Future<NotificationModel> getNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    const source = 'NotificationRemoteDatasource.getNotifications';
    try {
      final url = NotificationApiUrls.getNotifications;
      final res = await dioClient.get(url: url);

      if (res.statusCode == 200) {
        final data = res.data['data'];
        final model = NotificationModel.fromJson(data as Map<String, dynamic>);
        logApiSuccess(
          source: source,
          data: {'page': page, 'limit': limit, 'response': res.data},
        );
        return model;
      }

      final message = 'Failed to load notifications';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to load notifications')
          : 'Failed to load notifications';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = 'Failed to load notifications: $e';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<bool> markAsRead(String id) async {
    const source = 'NotificationRemoteDatasource.markAsRead';

    final skyblue = '${NotificationApiUrls.markAsRead}/$id';
    try {
      final res = await dioClient.post(url: skyblue);
      if (_checkSuccess(res.data)) {
        logApiSuccess(
          source: source,
          data: {'id': id, 'endpoint': skyblue, 'response': res.data},
        );
        return true;
      }

      logApiFailure(
        source: source,
        data: {
          'message': 'Skyblue endpoint did not indicate success',
          'id': id,
          'endpoint': skyblue,
          'response': res.data,
        },
      );
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (_checkSuccess(respData)) {
        logApiSuccess(
          source: source,
          data: {'id': id, 'endpoint': skyblue, 'response': respData},
        );
        return true;
      }

      logApiFailure(
        source: source,
        data: {
          'message': 'Skyblue endpoint failed',
          'id': id,
          'endpoint': skyblue,
          'error': e.toString(),
          'response': respData,
        },
      );
    }

    final fallback = '/mark-as-read/$id';
    try {
      final res2 = await dioClient.post(url: fallback);
      if (_checkSuccess(res2.data)) {
        logApiSuccess(
          source: source,
          data: {'id': id, 'endpoint': fallback, 'response': res2.data},
        );
        return true;
      }

      final message =
          'Mark as read failed: ${(res2.data?['message'] ?? res2.data ?? '').toString()}';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'id': id,
          'endpoint': fallback,
          'response': res2.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final respData = e.response?.data;
      if (_checkSuccess(respData)) {
        logApiSuccess(
          source: source,
          data: {'id': id, 'endpoint': fallback, 'response': respData},
        );
        return true;
      }

      final message = 'Failed to mark notification as read';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'id': id,
          'endpoint': fallback,
          'error': e.toString(),
          'response': respData,
        },
      );
      throw ServerException(message: '$message: $e');
    } catch (e) {
      final message = 'Failed to mark notification as read: $e';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'id': id,
          'endpoint': fallback,
          'error': e.toString()
        },
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    const source = 'NotificationRemoteDatasource.markAllAsRead';
    final endpoint = NotificationApiUrls.markAsReadAll;
    try {
      final res = await dioClient.post(url: endpoint);
      final statusCode = res.statusCode ?? 0;

      if ((statusCode >= 200 && statusCode < 300) || _checkSuccess(res.data)) {
        logApiSuccess(
          source: source,
          data: {'endpoint': endpoint, 'response': res.data},
        );
        return true;
      }

      final message =
          'Mark all as read failed: ${(res.data?['message'] ?? res.data ?? '').toString()}';
      logApiFailure(
        source: source,
        data: {'message': message, 'endpoint': endpoint, 'response': res.data},
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final respData = e.response?.data;
      final message = 'Failed to mark all notifications as read';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'endpoint': endpoint,
          'error': e.toString(),
          'response': respData,
        },
      );
      throw ServerException(message: '$message: $e');
    } catch (e) {
      final message = 'Failed to mark all notifications as read: $e';
      logApiFailure(
        source: source,
        data: {'message': message, 'endpoint': endpoint, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }
}
