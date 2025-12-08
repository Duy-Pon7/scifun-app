import 'package:equatable/equatable.dart';
import 'package:sci_fun/features/video/domain/entity/video_entity.dart';

class VideoModel extends Equatable {
  const VideoModel({
    required this.total,
    required this.data,
    required this.limit,
    required this.totalPages,
    required this.page,
  });

  final int? total;
  final List<DatumModel> data;
  final int? limit;
  final int? totalPages;
  final int? page;

  VideoModel copyWith({
    int? total,
    List<DatumModel>? data,
    int? limit,
    int? totalPages,
    int? page,
  }) {
    return VideoModel(
      total: total ?? this.total,
      data: data ?? this.data,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
    );
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      total: json["total"],
      data: json["data"] == null
          ? []
          : List<DatumModel>.from(
              json["data"]!.map((x) => DatumModel.fromJson(x))),
      limit: json["limit"],
      totalPages: json["totalPages"],
      page: json["page"],
    );
  }

  Map<String, dynamic> toJson() => {
        "total": total,
        "data": data.map((x) => x.toJson()).toList(),
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
      };

  VideoEntity toEntity() {
    return VideoEntity(
      total: total,
      data: data.map((x) => x.toEntity()).toList(),
      limit: limit,
      totalPages: totalPages,
      page: page,
    );
  }

  @override
  List<Object?> get props => [
        total,
        data,
        limit,
        totalPages,
        page,
      ];
}

class DatumModel extends Equatable {
  const DatumModel({
    required this.duration,
    required this.topic,
    required this.id,
    required this.title,
    required this.url,
  });

  final int? duration;
  final TopicModel? topic;
  final String? id;
  final String? title;
  final String? url;

  DatumModel copyWith({
    int? duration,
    TopicModel? topic,
    String? id,
    String? title,
    String? url,
  }) {
    return DatumModel(
      duration: duration ?? this.duration,
      topic: topic ?? this.topic,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  factory DatumModel.fromJson(Map<String, dynamic> json) {
    return DatumModel(
      duration: json["duration"],
      topic: json["topic"] == null ? null : TopicModel.fromJson(json["topic"]),
      id: json["_id"],
      title: json["title"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "topic": topic?.toJson(),
        "_id": id,
        "title": title,
        "url": url,
      };

  Datum toEntity() {
    return Datum(
      duration: duration,
      topic: topic?.toEntity(),
      id: id,
      title: title,
      url: url,
    );
  }

  @override
  List<Object?> get props => [
        duration,
        topic,
        id,
        title,
        url,
      ];
}

class TopicModel extends Equatable {
  const TopicModel({
    required this.name,
    required this.description,
    required this.id,
  });

  final String? name;
  final String? description;
  final String? id;

  TopicModel copyWith({
    String? name,
    String? description,
    String? id,
  }) {
    return TopicModel(
      name: name ?? this.name,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      name: json["name"],
      description: json["description"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "_id": id,
      };

  Topic toEntity() {
    return Topic(
      name: name,
      description: description,
      id: id,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        id,
      ];
}
