import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.items,
    required super.pagination,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      items: json["items"] == null
          ? []
          : List<ItemModel>.from(
              json["items"]!.map((x) => ItemModel.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : PaginationModel.fromJson(json["pagination"]),
    );
  }

  @override
  List<Object?> get props => [
        items,
        pagination,
      ];
}

class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.message,
    required super.data,
    required super.link,
    required super.createdAt,
    required super.read,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["id"],
      userId: json["userId"],
      type: json["type"],
      title: json["title"],
      message: json["message"],
      data: json["data"] == null ? null : DataModel.fromJson(json["data"]),
      link: json["link"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      read: json["read"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        message,
        data,
        link,
        createdAt,
        read,
      ];
}

class DataModel extends Data {
  DataModel({
    required super.fromUserId,
    required super.commentId,
    required super.type,
    required super.parentId,
    required super.period,
    required super.oldRank,
    required super.subjectId,
    required super.change,
    required super.newRank,
    required super.subjectName,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      fromUserId: json["fromUserId"],
      commentId: json["commentId"],
      type: json["type"],
      parentId: json["parentId"],
      period: json["period"],
      oldRank: json["oldRank"],
      subjectId: json["subjectId"],
      change: json["change"],
      newRank: json["newRank"],
      subjectName: json["subjectName"],
    );
  }

  @override
  List<Object?> get props => [
        fromUserId,
        commentId,
        type,
        parentId,
        period,
        oldRank,
        subjectId,
        change,
        newRank,
        subjectName,
      ];
}

class PaginationModel extends Pagination {
  PaginationModel({
    required super.totalPages,
    required super.page,
    required super.total,
    required super.limit,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalPages: json["totalPages"],
      page: json["page"],
      total: json["total"],
      limit: json["limit"],
    );
  }

  @override
  List<Object?> get props => [
        totalPages,
        page,
        total,
        limit,
      ];
}
