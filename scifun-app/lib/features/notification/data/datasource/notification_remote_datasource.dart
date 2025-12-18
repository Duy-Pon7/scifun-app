import 'package:dio/dio.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/notification/data/model/notification_model.dart';

abstract interface class NotificationRemoteDatasource {
  Future<NotificationModel> getNotifications({int page = 1, int limit = 10});

  /// Mark a single notification as read. Returns true when API indicates success.
  Future<bool> markAsRead(String id);

  /// Mark all notifications as read. Returns true when API indicates success.
  Future<bool> markAllAsRead();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioClient dioClient;

  NotificationRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<NotificationModel> getNotifications(
      {int page = 1, int limit = 10}) async {
    try {
      final url = NotificationApiUrls.getNotifications;
      // debug
      print('NotificationRemoteDatasource GET: $url');
      final res = await dioClient.get(
        url: url,
      );
      print('Response notification: ${res.data}');
      if (res.statusCode == 200) {
        final data = res.data['data'];
        return NotificationModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Failed to load notifications');
      }
    } catch (e) {
      print('Error in getNotifications: $e');
      throw ServerException(message: 'Failed to load notifications: $e');
    }
  }

  @override
  Future<bool> markAsRead(String id) async {
    // Helper to check response message
    bool _checkSuccess(dynamic data) {
      final message = (data?['message'] ?? data ?? '').toString();
      final lower = message.toLowerCase();
      return lower.contains('thành công') || lower.contains('thanh cong');
    }

    // Try primary endpoint: /notifications/read/{id}
    final primary = '${NotificationApiUrls.markAsRead}/$id';
    print('NotificationRemoteDatasource POST primary: $primary');

    try {
      final res = await dioClient.post(url: primary);
      print('Response markAsRead primary: ${res.data}');

      // Some servers return a success message in the body but use a non-200 status code.
      // Accept success when the response body indicates it, regardless of HTTP status.
      if (_checkSuccess(res.data)) {
        return true;
      }

      // If not successful, fallthrough to try alternative endpoint
      print('Primary mark-as-read did not indicate success, trying fallback');
    } catch (e) {
      // If Dio threw due to a non-200 status, the response may still contain success information.
      if (e is DioException && e.response != null) {
        final respData = e.response!.data;
        print('Primary markAsRead returned error with body: $respData');
        if (_checkSuccess(respData)) {
          return true;
        }
      }

      print('Primary markAsRead failed: $e, trying fallback');
    }

    // Fallback endpoint used by some servers: /mark-as-read/{id}
    final fallback = '/mark-as-read/$id';
    print('NotificationRemoteDatasource POST fallback: $fallback');

    try {
      final res2 = await dioClient.post(url: fallback);
      print('Response markAsRead fallback: ${res2.data}');

      if (_checkSuccess(res2.data)) {
        return true;
      }

      final message = (res2.data?['message'] ?? res2.data ?? '').toString();
      throw ServerException(message: 'Mark as read failed: $message');
    } catch (e) {
      // Consider bodies attached to non-200 Dio errors as potential success indicators
      if (e is DioException && e.response != null) {
        final respData = e.response!.data;
        print('Fallback markAsRead returned error with body: $respData');
        if (_checkSuccess(respData)) {
          return true;
        }
      }

      print('Error in markAsRead fallback: $e');
      throw ServerException(message: 'Failed to mark notification as read: $e');
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    // Helper to check response message
    bool _checkSuccess(dynamic data) {
      final message = (data?['message'] ?? data ?? '').toString();
      final lower = message.toLowerCase();
      return lower.contains('thành công') || lower.contains('thanh cong');
    }

    // Primary endpoint: configured URL
    final primary = NotificationApiUrls.markAsReadAll;
    print('NotificationRemoteDatasource POST primary (mark all): $primary');

    try {
      final res = await dioClient.post(url: primary);
      print('Response markAllAsRead primary: ${res.data}');

      // Accept success when response body indicates success, even if HTTP status is non-200
      if (_checkSuccess(res.data)) {
        return true;
      }

      print(
          'Primary mark-all-as-read did not indicate success, trying fallback');
    } catch (e) {
      if (e is DioException && e.response != null) {
        final respData = e.response!.data;
        print('Primary markAllAsRead returned error with body: $respData');
        if (_checkSuccess(respData)) {
          return true;
        }
      }

      print('Primary markAllAsRead failed: $e, trying fallback');
    }

    // Fallback endpoint used by some servers
    final fallback = '/api/v1/mark-all-as-read';
    print('NotificationRemoteDatasource POST fallback (mark all): $fallback');

    try {
      final res2 = await dioClient.post(url: fallback);
      print('Response markAllAsRead fallback: ${res2.data}');

      if (_checkSuccess(res2.data)) {
        return true;
      }

      final message = (res2.data?['message'] ?? res2.data ?? '').toString();
      throw ServerException(message: 'Mark all as read failed: $message');
    } catch (e) {
      if (e is DioException && e.response != null) {
        final respData = e.response!.data;
        print('Fallback markAllAsRead returned error with body: $respData');
        if (_checkSuccess(respData)) {
          return true;
        }
      }

      print('Error in markAllAsRead fallback: $e');
      throw ServerException(
          message: 'Failed to mark all notifications as read: $e');
    }
  }
}
