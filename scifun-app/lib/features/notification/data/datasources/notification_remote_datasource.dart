import 'dart:developer';

import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/features/notification/data/models/noti_model.dart';

abstract interface class NotificationRemoteDatasource {
  Future<List<NotiModel>> getNotifications({
    required int page,
  });
  Future<NotiModel> getNotificationDetail({required int id});
  Future<void> markAsRead({required int id});
  Future<void> markAsReadAll();
  Future<void> deleteNotification({required int id});
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioClient dioClient;

  NotificationRemoteDatasourceImpl({required this.dioClient});

  // Get notification list
  @override
  Future<List<NotiModel>> getNotifications({required int page}) async {
    try {
      // Gửi yêu cầu đến API
      final res = await dioClient.get(
        url: '${NotificationApiUrls.getAllNotifications}?page=$page',
      );

      // Lấy dữ liệu map từ response
      final rawMap = res.data["data"]["notifications"] as Map<String, dynamic>;

      // Parse từng danh sách theo ngày
      final List<NotiModel> notifications = [];

      rawMap.forEach((date, list) {
        if (list is List) {
          final parsedDate = DateTime.tryParse(date);
          if (parsedDate != null) {
            for (final item in list) {
              try {
                final noti = NotiModel.fromJson(
                  item,
                  fallbackDate: parsedDate,
                );
                notifications.add(noti);
              } catch (e) {
                log("❌ Lỗi parse item: $item\nError: $e");
              }
            }
          }
        }
      });

      return notifications;
    } on ServerException {
      // Ném lại ngoại lệ nếu là ServerException
      rethrow;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<NotiModel> getNotificationDetail({required int id}) async {
    try {
      final res = await dioClient.get(
        url: '${NotificationApiUrls.getNotifications}/$id',
      );

      final data = res.data["data"];
      if (data == null || data is! Map<String, dynamic>) {
        throw ServerException(message: "Dữ liệu không hợp lệ.");
      }
      final fallbackDate =
          DateTime.tryParse(data["created_at"] ?? "") ?? DateTime.now();

      return NotiModel.fromJson(data, fallbackDate: fallbackDate);
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<void> markAsRead({required int id}) async {
    try {
      await dioClient.put(
        url: NotificationApiUrls.markAsRead,
        data: {
          "id": id.toString(),
        },
      );
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<void> markAsReadAll() async {
    try {
      await dioClient.post(
        url: NotificationApiUrls.markAsReadAll,
      );
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<void> deleteNotification({required int id}) async {
    print("id123 $id");
    try {
      await dioClient.delete(
        url: '${NotificationApiUrls.deleteNoti}/$id',
      );
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}
