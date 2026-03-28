class UserOrderHistoryEntity {
  const UserOrderHistoryEntity({
    required this.total,
    required this.orders,
    required this.limit,
    required this.totalPages,
    required this.page,
  });

  final int total;
  final List<UserOrderEntity> orders;
  final int limit;
  final int totalPages;
  final int page;
}

class UserOrderEntity {
  const UserOrderEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.total,
    required this.currency,
    required this.provider,
    required this.providerRef,
    required this.status,
    required this.planTier,
    required this.period,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? type;
  final double total;
  final String? currency;
  final String? provider;
  final String? providerRef;
  final String? status;
  final String? planTier;
  final String? period;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
