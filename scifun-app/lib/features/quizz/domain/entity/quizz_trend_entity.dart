import 'package:equatable/equatable.dart';

class QuizzTrend extends Equatable {
  QuizzTrend({
    required this.total,
    required this.data,
  });

  final int? total;
  final List<Datum> data;

  QuizzTrend copyWith({
    int? total,
    List<Datum>? data,
  }) {
    return QuizzTrend(
      total: total ?? this.total,
      data: data ?? this.data,
    );
  }

  factory QuizzTrend.fromJson(Map<String, dynamic> json) {
    return QuizzTrend(
      total: json["total"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "total": total,
        "data": data.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        total,
        data,
      ];
}

class Datum extends Equatable {
  Datum({
    required this.duration,
    required this.questionCount,
    required this.score,
    required this.description,
    required this.topic,
    required this.lastAttemptAt,
    required this.id,
    required this.title,
    required this.uniqueUserCount,
  });

  final int? duration;
  final int? questionCount;
  final double? score;
  final String? description;
  final Topic? topic;
  final DateTime? lastAttemptAt;
  final String? id;
  final String? title;
  final int? uniqueUserCount;

  Datum copyWith({
    int? duration,
    int? questionCount,
    double? score,
    String? description,
    Topic? topic,
    DateTime? lastAttemptAt,
    String? id,
    String? title,
    int? uniqueUserCount,
  }) {
    return Datum(
      duration: duration ?? this.duration,
      questionCount: questionCount ?? this.questionCount,
      score: score ?? this.score,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      id: id ?? this.id,
      title: title ?? this.title,
      uniqueUserCount: uniqueUserCount ?? this.uniqueUserCount,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      duration: json["duration"],
      questionCount: json["questionCount"],
      score: json["score"],
      description: json["description"],
      topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
      lastAttemptAt: DateTime.tryParse(json["lastAttemptAt"] ?? ""),
      id: json["_id"],
      title: json["title"],
      uniqueUserCount: json["uniqueUserCount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "questionCount": questionCount,
        "score": score,
        "description": description,
        "topic": topic?.toJson(),
        "lastAttemptAt": lastAttemptAt?.toIso8601String(),
        "_id": id,
        "title": title,
        "uniqueUserCount": uniqueUserCount,
      };

  @override
  List<Object?> get props => [
        duration,
        questionCount,
        score,
        description,
        topic,
        lastAttemptAt,
        id,
        title,
        uniqueUserCount,
      ];
}

class Topic extends Equatable {
  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.subject,
    required this.target,
    required this.source,
  });

  final String? id;
  final String? name;
  final String? description;
  final Subject? subject;
  final TopicTarget? target;
  final Source? source;

  Topic copyWith({
    String? id,
    String? name,
    String? description,
    Subject? subject,
    TopicTarget? target,
    Source? source,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      target: target ?? this.target,
      source: source ?? this.source,
    );
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      subject:
          json["subject"] == null ? null : Subject.fromJson(json["subject"]),
      target:
          json["target"] == null ? null : TopicTarget.fromJson(json["target"]),
      source: json["source"] == null ? null : Source.fromJson(json["source"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "subject": subject?.toJson(),
        "target": target?.toJson(),
        "source": source?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        subject,
        target,
        source,
      ];
}

class Source extends Equatable {
  Source({
    required this.id,
    required this.collectionName,
    required this.databaseName,
  });

  final Id? id;
  final String? collectionName;
  final dynamic databaseName;

  Source copyWith({
    Id? id,
    String? collectionName,
    dynamic databaseName,
  }) {
    return Source(
      id: id ?? this.id,
      collectionName: collectionName ?? this.collectionName,
      databaseName: databaseName ?? this.databaseName,
    );
  }

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["id"] == null ? null : Id.fromJson(json["id"]),
      collectionName: json["collectionName"],
      databaseName: json["databaseName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id?.toJson(),
        "collectionName": collectionName,
        "databaseName": databaseName,
      };

  @override
  List<Object?> get props => [
        id,
        collectionName,
        databaseName,
      ];
}

class Id extends Equatable {
  Id({
    required this.timestamp,
    required this.date,
  });

  final int? timestamp;
  final DateTime? date;

  Id copyWith({
    int? timestamp,
    DateTime? date,
  }) {
    return Id(
      timestamp: timestamp ?? this.timestamp,
      date: date ?? this.date,
    );
  }

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(
      timestamp: json["timestamp"],
      date: DateTime.tryParse(json["date"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "date": date?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        timestamp,
        date,
      ];
}

class Subject extends Equatable {
  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.maxTopics,
    required this.image,
    required this.target,
    required this.source,
  });

  final String? id;
  final String? name;
  final String? description;
  final int? maxTopics;
  final String? image;
  final SubjectTarget? target;
  final Source? source;

  Subject copyWith({
    String? id,
    String? name,
    String? description,
    int? maxTopics,
    String? image,
    SubjectTarget? target,
    Source? source,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      maxTopics: maxTopics ?? this.maxTopics,
      image: image ?? this.image,
      target: target ?? this.target,
      source: source ?? this.source,
    );
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      maxTopics: json["maxTopics"],
      image: json["image"],
      target: json["target"] == null
          ? null
          : SubjectTarget.fromJson(json["target"]),
      source: json["source"] == null ? null : Source.fromJson(json["source"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "maxTopics": maxTopics,
        "image": image,
        "target": target?.toJson(),
        "source": source?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        maxTopics,
        image,
        target,
        source,
      ];
}

class SubjectTarget extends Equatable {
  SubjectTarget({
    required this.id,
    required this.name,
    required this.description,
    required this.maxTopics,
    required this.image,
  });

  final String? id;
  final String? name;
  final String? description;
  final int? maxTopics;
  final String? image;

  SubjectTarget copyWith({
    String? id,
    String? name,
    String? description,
    int? maxTopics,
    String? image,
  }) {
    return SubjectTarget(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      maxTopics: maxTopics ?? this.maxTopics,
      image: image ?? this.image,
    );
  }

  factory SubjectTarget.fromJson(Map<String, dynamic> json) {
    return SubjectTarget(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      maxTopics: json["maxTopics"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "maxTopics": maxTopics,
        "image": image,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        maxTopics,
        image,
      ];
}

class TopicTarget extends Equatable {
  TopicTarget({
    required this.id,
    required this.name,
    required this.description,
    required this.subject,
  });

  final String? id;
  final String? name;
  final String? description;
  final Subject? subject;

  TopicTarget copyWith({
    String? id,
    String? name,
    String? description,
    Subject? subject,
  }) {
    return TopicTarget(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subject: subject ?? this.subject,
    );
  }

  factory TopicTarget.fromJson(Map<String, dynamic> json) {
    return TopicTarget(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      subject:
          json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "subject": subject?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        subject,
      ];
}
