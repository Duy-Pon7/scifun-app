import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/plan/data/model/plan_model.dart' as plan_model;
import 'package:sci_fun/features/plan/domain/entity/checkout_response.dart';

abstract interface class PlanRemoteDatasource {
  Future<List<plan_model.Plan>> getAllPlans();

  /// Create a checkout session and return CheckoutResponse
  Future<CheckoutResponse> createCheckout(
      {required int price, required int durationDays});

  /// Verify ZaloPay payment with appTransId and grant the plan for durationDays
  Future<String> verifyPayment(
      {required String appTransId, required int durationDays});
}

class PlanRemoteDatasourceImpl implements PlanRemoteDatasource {
  final DioClient dioClient;

  PlanRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<plan_model.Plan>> getAllPlans() async {
    try {
      final res = await dioClient.get(url: PlansApiUrl.getPlansList);
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data'] as List<dynamic>;
        return data
            .map((planJson) =>
                plan_model.Plan.fromJson(planJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load plans');
      }
    } catch (e) {
      throw Exception('Failed to load plans: $e');
    }
  }

  @override
  Future<CheckoutResponse> createCheckout(
      {required int price, required int durationDays}) async {
    try {
      // External checkout service
      const checkoutUrl = 'https://java-app-9trd.onrender.com/api/v1/checkout';
      final res = await dioClient.post(
          url: checkoutUrl,
          data: {'price': price, 'durationDays': durationDays});
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data as Map<String, dynamic>;
        return CheckoutResponse.fromJson(data);
      }
      throw Exception('Failed to create checkout');
    } catch (e) {
      throw Exception('Failed to create checkout: $e');
    }
  }

  @override
  Future<String> verifyPayment(
      {required String appTransId, required int durationDays}) async {
    print(
        'Verifying payment with appTransId: $appTransId for $durationDays days');
    try {
      const verifyUrl =
          'https://java-app-9trd.onrender.com/api/v1/zalopay/verifyPayment';
      final res = await dioClient.post(
        url: verifyUrl,
        data: {'appTransId': appTransId, 'durationDays': durationDays},
      );
      print('Verify payment response status: ${res.statusCode}');
      print('Verify payment response data: ${res.data}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data as Map<String, dynamic>;
        final message = data['message'] as String? ?? 'Xác thực thành công';
        return message;
      }

      throw Exception('Failed to verify payment');
    } catch (e) {
      throw Exception('Failed to verify payment: $e');
    }
  }
}
