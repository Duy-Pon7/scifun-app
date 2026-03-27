import 'package:equatable/equatable.dart';

class CheckoutResponse extends Equatable {
  const CheckoutResponse({
    required this.payUrl,
    required this.durationDays,
    this.appTransId,
    this.orderId,
    this.provider,
    this.deeplink,
    this.qrCodeUrl,
  });

  final String payUrl;
  final String? appTransId;
  final int durationDays;
  final String? orderId;
  final String? provider;
  final String? deeplink;
  final String? qrCodeUrl;

  String get paymentRef => orderId ?? appTransId ?? '';

  String get preferredLaunchUrl =>
      (deeplink != null && deeplink!.isNotEmpty) ? deeplink! : payUrl;

  static String? _toNullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    final payUrl =
        _toNullableString(json['payUrl']) ?? _toNullableString(json['pay_url']);
    final deeplink = _toNullableString(json['deeplink']);
    final resolvedPayUrl = payUrl ?? deeplink ?? '';

    return CheckoutResponse(
      payUrl: resolvedPayUrl,
      appTransId: _toNullableString(json['appTransId']) ??
          _toNullableString(json['app_trans_id']),
      durationDays: _toInt(json['durationDays'] ?? json['duration_days']),
      orderId: _toNullableString(json['orderId'] ?? json['order_id']),
      provider: _toNullableString(json['provider']),
      deeplink: deeplink,
      qrCodeUrl: _toNullableString(json['qrCodeUrl'] ?? json['qr_code_url']),
    );
  }

  @override
  List<Object?> get props => [
        payUrl,
        appTransId,
        durationDays,
        orderId,
        provider,
        deeplink,
        qrCodeUrl
      ];
}
