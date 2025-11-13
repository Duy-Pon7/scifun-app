class PackageHistoryEntity {
  PackageHistoryEntity({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.notifications,
  });

  final int? total;
  final int? perPage;
  final int? currentPage;
  final List<NotificationEntity> notifications;
}

class BankEntity {
  BankEntity({
    required this.account,
    required this.name,
    required this.accountHolder,
  });

  final String? account;
  final String? name;
  final String? accountHolder;
}

class NotificationEntity {
  NotificationEntity({
    required this.id,
    required this.cancellationReason,
    required this.type,
    required this.approvalStatus,
    required this.paymentConfirmationImage,
    required this.createdAt,
    required this.package,
    required this.bank,
  });

  final int? id;
  final String? cancellationReason;
  final String? type;
  final String? approvalStatus;
  final String? paymentConfirmationImage;
  final BankEntity? bank;
  final DateTime? createdAt;
  final PackageEntity? package;
}

class PackageEntity {
  PackageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  final int? id;
  final String? name;
  final List<String> description;
  final String? price;
}
