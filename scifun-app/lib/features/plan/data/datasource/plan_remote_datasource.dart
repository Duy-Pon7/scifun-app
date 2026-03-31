import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/plan/data/model/plan_model.dart' as plan_model;
import 'package:sci_fun/features/plan/domain/entity/checkout_response.dart';

abstract interface class PlanRemoteDatasource {
  Future<List<plan_model.Plan>> getAllPlans();

  Future<CheckoutResponse> createCheckout({
    required int price,
    required int durationDays,
  });

  Future<String> verifyPayment({
    required String appTransId,
    required int durationDays,
  });
}

class PlanRemoteDatasourceImpl implements PlanRemoteDatasource {
  final DioClient dioClient;

  PlanRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<plan_model.Plan>> getAllPlans() async {
    const source = 'PlanRemoteDatasource.getAllPlans';
    try {
      final res = await dioClient.get(url: PlansApiUrl.getPlansList);
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data'] as List<dynamic>;
        final plans = data
            .map(
              (planJson) =>
                  plan_model.Plan.fromJson(planJson as Map<String, dynamic>),
            )
            .toList();
        logApiSuccess(
          source: source,
          data: {'count': plans.length, 'response': res.data},
        );
        return plans;
      }

      final message = 'Failed to load plans';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw Exception(message);
    } catch (e) {
      logApiFailure(
        source: source,
        data: {'message': 'Failed to load plans', 'error': e.toString()},
      );
      throw Exception('Failed to load plans: $e');
    }
  }

  @override
  Future<CheckoutResponse> createCheckout({
    required int price,
    required int durationDays,
  }) async {
    const source = 'PlanRemoteDatasource.createCheckout';
    try {
      final res = await dioClient.post(
        url: PlansApiUrl.checkout,
        data: {
          'price': price,
          'durationDays': durationDays,
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data as Map<String, dynamic>;
        logApiSuccess(source: source, data: data);
        return CheckoutResponse.fromJson(data);
      }

      final message = 'Failed to create checkout';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw Exception(message);
    } catch (e) {
      logApiFailure(
        source: source,
        data: {'message': 'Failed to create checkout', 'error': e.toString()},
      );
      throw Exception('Failed to create checkout: $e');
    }
  }

  @override
  Future<String> verifyPayment({
    required String appTransId,
    required int durationDays,
  }) async {
    const source = 'PlanRemoteDatasource.verifyPayment';
    try {
      final res = await dioClient.post(
        url: PlansApiUrl.verifyPayment,
        data: {
          'appTransId': appTransId,
          'durationDays': durationDays,
        },
      );
      logResponseData(res.data, source: source);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data as Map<String, dynamic>;
        final message = data['message'] as String? ?? 'Xac thuc thanh cong';
        logApiSuccess(
            source: source, data: {'message': message, 'response': data});
        return message;
      }

      final message = 'Failed to verify payment';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw Exception(message);
    } catch (e) {
      logApiFailure(
        source: source,
        data: {'message': 'Failed to verify payment', 'error': e.toString()},
      );
      throw Exception('Failed to verify payment: $e');
    }
  }
}
