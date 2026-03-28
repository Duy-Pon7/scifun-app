import 'package:sci_fun/features/profile/domain/entities/order_history_entity.dart';

class UserOrderHistoryModel extends UserOrderHistoryEntity {
  const UserOrderHistoryModel({
    required super.total,
    required super.orders,
    required super.limit,
    required super.totalPages,
    required super.page,
  });

  factory UserOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawOrders = json['data'] as List<dynamic>? ?? const [];

    return UserOrderHistoryModel(
      total: _toInt(json['total']),
      orders: rawOrders
          .map((item) => UserOrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      limit: _toInt(json['limit']),
      totalPages: _toInt(json['totalPages']),
      page: _toInt(json['page']),
    );
  }
}

class UserOrderModel extends UserOrderEntity {
  const UserOrderModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.total,
    required super.currency,
    required super.provider,
    required super.providerRef,
    required super.status,
    required super.planTier,
    required super.period,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    return UserOrderModel(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      type: json['type']?.toString(),
      total: _toDouble(json['total']),
      currency: json['currency']?.toString(),
      provider: json['provider']?.toString(),
      providerRef: json['providerRef']?.toString(),
      status: json['status']?.toString(),
      planTier: json['planTier']?.toString(),
      period: json['period']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return 0;
}
