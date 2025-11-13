import 'package:sci_fun/features/profile/domain/entities/package_history_entity.dart';

class PackageHistoryModel extends PackageHistoryEntity {
  PackageHistoryModel({
    required super.total,
    required super.perPage,
    required super.currentPage,
    required super.notifications,
  });

  factory PackageHistoryModel.fromJson(Map<String, dynamic> json) {
    return PackageHistoryModel(
      total: json["total"],
      perPage: json["per_page"],
      currentPage: json["current_page"],
      notifications: json["notifications"] == null
          ? []
          : List<NotificationModel>.from(
              json["notifications"]!.map((x) => NotificationModel.fromJson(x))),
    );
  }
}

class BankModel extends BankEntity {
  BankModel({
    required super.account,
    required super.name,
    required super.accountHolder,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      account: json["account"],
      name: json["name"],
      accountHolder: json["account_holder"],
    );
  }
}

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.cancellationReason,
    required super.type,
    required super.approvalStatus,
    required super.paymentConfirmationImage,
    required super.createdAt,
    required super.package,
    required super.bank,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      cancellationReason: json["cancellation_reason"],
      type: json["type"],
      approvalStatus: json["approval_status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      paymentConfirmationImage: json["payment_confirmation_image"],
      package: json["package"] == null
          ? null
          : PackageModel.fromJson(json["package"]),
      bank: json["bank"] == null ? null : BankModel.fromJson(json["bank"]),
    );
  }
}

class PackageModel extends PackageEntity {
  PackageModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json["id"],
      name: json["name"],
      description: json["description"] == null
          ? []
          : List<String>.from(json["description"]!.map((x) => x)),
      price: json["price"],
    );
  }
}
