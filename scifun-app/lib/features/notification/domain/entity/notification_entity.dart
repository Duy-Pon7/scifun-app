import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.items,
    required this.pagination,
  });

  final List<Item> items;
  final Pagination? pagination;

  NotificationEntity copyWith({
    List<Item>? items,
    Pagination? pagination,
  }) {
    return NotificationEntity(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
    );
  }

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : Pagination.fromJson(json["pagination"]),
    );
  }

  @override
  List<Object?> get props => [
        items,
        pagination,
      ];
}

class Item extends Equatable {
  const Item({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.link,
    required this.createdAt,
    required this.read,
  });

  final String? id;
  final String? userId;
  final String? type;
  final String? title;
  final String? message;
  final Data? data;
  final String? link;
  final DateTime? createdAt;
  final bool? read;

  Item copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? message,
    Data? data,
    String? link,
    DateTime? createdAt,
    bool? read,
  }) {
    return Item(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      userId: json["userId"],
      type: json["type"],
      title: json["title"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data extends Equatable {
  const Data({
    required this.fromUserId,
    required this.commentId,
    required this.type,
    required this.parentId,
    required this.period,
    required this.oldRank,
    required this.subjectId,
    required this.change,
    required this.newRank,
    required this.subjectName,
  });

  final String? fromUserId;
  final String? commentId;
  final String? type;
  final String? parentId;
  final String? period;
  final int? oldRank;
  final String? subjectId;
  final String? change;
  final int? newRank;
  final String? subjectName;

  Data copyWith({
    String? fromUserId,
    String? commentId,
    String? type,
    String? parentId,
    String? period,
    int? oldRank,
    String? subjectId,
    String? change,
    int? newRank,
    String? subjectName,
  }) {
    return Data(
      fromUserId: fromUserId ?? this.fromUserId,
      commentId: commentId ?? this.commentId,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      period: period ?? this.period,
      oldRank: oldRank ?? this.oldRank,
      subjectId: subjectId ?? this.subjectId,
      change: change ?? this.change,
      newRank: newRank ?? this.newRank,
      subjectName: subjectName ?? this.subjectName,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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

class Pagination extends Equatable {
  const Pagination({
    required this.totalPages,
    required this.page,
    required this.total,
    required this.limit,
  });

  final int? totalPages;
  final int? page;
  final int? total;
  final int? limit;

  Pagination copyWith({
    int? totalPages,
    int? page,
    int? total,
    int? limit,
  }) {
    return Pagination(
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
      total: total ?? this.total,
      limit: limit ?? this.limit,
    );
  }

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
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
