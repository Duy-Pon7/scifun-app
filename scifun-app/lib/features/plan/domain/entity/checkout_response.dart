import 'package:equatable/equatable.dart';

class CheckoutResponse extends Equatable {
  const CheckoutResponse({
    required this.payUrl,
    required this.appTransId,
    required this.durationDays,
    this.orderId,
    this.provider,
  });

  final String payUrl;
  final String appTransId;
  final int durationDays;
  final String? orderId;
  final String? provider;

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      payUrl: json['payUrl'] as String,
      appTransId: json['appTransId'] as String,
      durationDays: json['durationDays'] as int,
      orderId: json['orderId'] as String?,
      provider: json['provider'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [payUrl, appTransId, durationDays, orderId, provider];
}
