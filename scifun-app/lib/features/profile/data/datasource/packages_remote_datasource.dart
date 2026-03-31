import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/message_constants.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/profile/data/models/instructions_model.dart';
import 'package:sci_fun/features/profile/data/models/order_history_model.dart';
import 'package:sci_fun/features/profile/data/models/package_history_model.dart';
import 'package:sci_fun/features/profile/data/models/packages_model.dart';

abstract interface class PackagesRemoteDatasource {
  Future<UserOrderHistoryModel> getOrderHistory({
    required int page,
    required int limit,
  });
  Future<List<NotificationModel>> getHistoryPackage({
    required int page,
  });
  Future<List<PackagesModel>> getpackages();
  Future<List<InstructionsModel>> getInstructions();
  Future<void> buyPackages({required int id, required File image});
}

class PackagesRemoteDatasourceImpl implements PackagesRemoteDatasource {
  final DioClient dioClient;

  PackagesRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<InstructionsModel>> getInstructions() async {
    const source = 'PackagesRemoteDatasource.getInstructions';
    try {
      final res = await dioClient.get(url: PackagesApiUrl.instructionsPackages);
      if (res.statusCode != 200) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failedGetInfo,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException();
      }

      final responseData = ResponseModel<List<InstructionsModel>>.fromJson(
        res.data,
        (json) => (json as List)
            .map((e) => InstructionsModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      logResponseData(responseData, source: source);

      if (responseData.status != 200 || responseData.data == null) {
        final message = responseData.message ?? MessageConstant.failedGetInfo;
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'response': res.data,
          },
        );
        throw ServerException(message: MessageConstant.failedGetInfo);
      }

      logApiSuccess(
        source: source,
        data: {'count': responseData.data!.length, 'response': res.data},
      );
      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {'message': MessageConstant.failedGetInfo, 'error': e.toString()},
      );
      throw ServerException(message: MessageConstant.failedGetInfo);
    }
  }

  @override
  Future<void> buyPackages({required int id, required File image}) async {
    const source = 'PackagesRemoteDatasource.buyPackages';
    try {
      final formData = FormData.fromMap({
        'id': id,
        'payment_confirmation_image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final res = await dioClient.post(
        url: PackagesApiUrl.buyPackages,
        data: formData,
      );

      if (res.statusCode != 200) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failedGetInfo,
            'id': id,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException();
      }

      final responseData = ResponseModel<dynamic>.fromJson(
        res.data,
        (data) => data,
      );
      logResponseData(responseData, source: source);

      if (responseData.status != 200) {
        final message = responseData.message ?? MessageConstant.failedGetInfo;
        logApiFailure(
          source: source,
          data: {'message': message, 'id': id, 'response': res.data},
        );
        throw ServerException(message: message);
      }

      logApiSuccess(
        source: source,
        data: {'id': id, 'response': res.data},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {
          'message': 'Loi khong xac dinh khi mua goi',
          'id': id,
          'error': e.toString()
        },
      );
      throw ServerException();
    }
  }

  @override
  Future<List<PackagesModel>> getpackages() async {
    const source = 'PackagesRemoteDatasource.getpackages';
    try {
      final res = await dioClient.get(url: PackagesApiUrl.getPackages);
      if (res.statusCode != 200) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failedGetInfo,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException();
      }

      final responseData = ResponseModel<List<PackagesModel>>.fromJson(
        res.data,
        (json) => (json as List)
            .map((e) => PackagesModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      logResponseData(responseData, source: source);

      if (responseData.status != 200 || responseData.data == null) {
        final message = responseData.message ?? MessageConstant.failedGetInfo;
        logApiFailure(
          source: source,
          data: {'message': message, 'response': res.data},
        );
        throw ServerException(message: MessageConstant.failedGetInfo);
      }

      logApiSuccess(
        source: source,
        data: {'count': responseData.data!.length, 'response': res.data},
      );
      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {'message': 'Loi khong xac dinh', 'error': e.toString()},
      );
      throw ServerException();
    }
  }

  @override
  Future<List<NotificationModel>> getHistoryPackage({required int page}) async {
    const source = 'PackagesRemoteDatasource.getHistoryPackage';
    try {
      final res = await dioClient.get(
        url: '${PackagesApiUrl.historyPackages}?page=$page',
      );

      if (res.statusCode == 200) {
        final json = res.data;
        final data = json['data'] as Map<String, dynamic>? ?? {};
        final notificationsJson = data['notifications'] as List<dynamic>? ?? [];

        final notifications = notificationsJson
            .map((e) => NotificationModel.fromJson(e))
            .toList();

        logApiSuccess(
          source: source,
          data: {
            'page': page,
            'count': notifications.length,
            'response': res.data
          },
        );
        return notifications;
      }

      final message = res.statusMessage ?? 'Unknown error';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'page': page,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = e.toString();
      logApiFailure(
        source: source,
        data: {'message': message, 'page': page, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<UserOrderHistoryModel> getOrderHistory({
    required int page,
    required int limit,
  }) async {
    const source = 'PackagesRemoteDatasource.getOrderHistory';
    try {
      final res = await dioClient.get(
        url: '${OrdersApiUrl.getUserOrders}?page=$page&limit=$limit',
      );

      if (res.statusCode != 200) {
        final message = res.statusMessage ?? 'Unknown error';
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'page': page,
            'limit': limit,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException(message: message);
      }

      final json = res.data;
      if (json is! Map<String, dynamic>) {
        const message = 'Invalid response format';
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'page': page,
            'limit': limit,
            'response': res.data
          },
        );
        throw ServerException(message: message);
      }

      final status = json['status'];
      if (status != 200) {
        final message =
            json['message']?.toString() ?? MessageConstant.failedGetInfo;
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'page': page,
            'limit': limit,
            'response': res.data
          },
        );
        throw ServerException(message: message);
      }

      final data = json['data'];
      if (data is! Map<String, dynamic>) {
        const message = 'Missing order history data';
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'page': page,
            'limit': limit,
            'response': res.data
          },
        );
        throw ServerException(message: message);
      }

      final history = UserOrderHistoryModel.fromJson(data);
      logApiSuccess(
        source: source,
        data: {'page': page, 'limit': limit, 'response': res.data},
      );
      return history;
    } on ServerException {
      rethrow;
    } catch (e) {
      final message = e.toString();
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'page': page,
          'limit': limit,
          'error': e.toString()
        },
      );
      throw ServerException(message: message);
    }
  }
}
