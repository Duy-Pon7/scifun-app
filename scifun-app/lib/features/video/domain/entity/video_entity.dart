import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  const VideoEntity({
    required this.total,
    required this.data,
    required this.limit,
    required this.totalPages,
    required this.page,
  });

  final int? total;
  final List<Datum> data;
  final int? limit;
  final int? totalPages;
  final int? page;

  VideoEntity copyWith({
    int? total,
    List<Datum>? data,
    int? limit,
    int? totalPages,
    int? page,
  }) {
    return VideoEntity(
      total: total ?? this.total,
      data: data ?? this.data,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
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

class Datum extends Equatable {
  const Datum({
    required this.duration,
    required this.topic,
    required this.id,
    required this.title,
    required this.url,
  });

  final int? duration;
  final Topic? topic;
  final String? id;
  final String? title;
  final String? url;

  Datum copyWith({
    int? duration,
    Topic? topic,
    String? id,
    String? title,
    String? url,
  }) {
    return Datum(
      duration: duration ?? this.duration,
      topic: topic ?? this.topic,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
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

class Topic extends Equatable {
  const Topic({
    required this.name,
    required this.description,
    required this.id,
  });

  final String? name;
  final String? description;
  final String? id;

  Topic copyWith({
    String? name,
    String? description,
    String? id,
  }) {
    return Topic(
      name: name ?? this.name,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        id,
      ];
}
