import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.content,
    required super.parentId,
    required super.repliesCount,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  CommentModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    String? parentId,
    int? repliesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
      repliesCount: repliesCount ?? this.repliesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      content: json['content'] as String?,
      parentId: json['parentId'] as String?,
      repliesCount: json['repliesCount'] is int
          ? json['repliesCount'] as int
          : (json['repliesCount'] != null
              ? int.tryParse(json['repliesCount'].toString())
              : null),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'content': content,
        'parentId': parentId,
        'repliesCount': repliesCount,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        content,
        parentId,
        repliesCount,
        createdAt,
        updatedAt,
      ];
}
