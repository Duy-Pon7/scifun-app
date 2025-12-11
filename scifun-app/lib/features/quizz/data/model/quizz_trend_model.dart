import 'package:sci_fun/features/quizz/domain/entity/quizz_trend_entity.dart';

class QuizzTrendModel extends QuizzTrend {
  QuizzTrendModel({required super.total, required super.data});

  factory QuizzTrendModel.fromJson(Map<String, dynamic> json) {
    return QuizzTrendModel(
      total: (json['total'] as num?)?.toInt(),
      data: json['data'] == null
          ? []
          : List<DatumModel>.from(
              (json['data'] as List).map((x) => DatumModel.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'total': total,
        'data': data.map((x) => (x as DatumModel).toJson()).toList(),
      };
}

class DatumModel extends Datum {
  DatumModel({
    required super.duration,
    required super.questionCount,
    required super.score,
    required super.description,
    required super.topic,
    required super.lastAttemptAt,
    required super.id,
    required super.title,
    required super.uniqueUserCount,
  });

  factory DatumModel.fromJson(Map<String, dynamic> json) {
    return DatumModel(
      duration: (json['duration'] as num?)?.toInt(),
      questionCount: (json['questionCount'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toDouble(),
      description: json['description'],
      topic: json['topic'] != null ? TopicModel.fromJson(json['topic']) : null,
      lastAttemptAt: DateTime.tryParse(json['lastAttemptAt'] ?? ''),
      id: json['_id'],
      title: json['title'],
      uniqueUserCount: (json['uniqueUserCount'] as num?)?.toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'duration': duration,
        'questionCount': questionCount,
        'score': score,
        'description': description,
        'topic': topic == null ? null : (topic as TopicModel).toJson(),
        'lastAttemptAt': lastAttemptAt?.toIso8601String(),
        '_id': id,
        'title': title,
        'uniqueUserCount': uniqueUserCount,
      };
}

class TopicModel extends Topic {
  TopicModel({
    required super.id,
    required super.name,
    required super.description,
    required super.subject,
    required super.target,
    required super.source,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      subject: json['subject'] != null
          ? SubjectModel.fromJson(json['subject'])
          : null,
      target: json['target'] != null
          ? TopicTargetModel.fromJson(json['target'])
          : null,
      source:
          json['source'] != null ? SourceModel.fromJson(json['source']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'subject': subject == null ? null : (subject as SubjectModel).toJson(),
        'target': target == null ? null : (target as TopicTargetModel).toJson(),
        'source': source == null ? null : (source as SourceModel).toJson(),
      };
}

class SourceModel extends Source {
  SourceModel({
    required super.id,
    required super.collectionName,
    required super.databaseName,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'] != null ? IdModel.fromJson(json['id']) : null,
      collectionName: json['collectionName'],
      databaseName: json['databaseName'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id == null ? null : (id as IdModel).toJson(),
        'collectionName': collectionName,
        'databaseName': databaseName,
      };
}

class IdModel extends Id {
  IdModel({required super.timestamp, required super.date});

  factory IdModel.fromJson(Map<String, dynamic> json) {
    return IdModel(
      timestamp: (json['timestamp'] as num?)?.toInt(),
      date: DateTime.tryParse(json['date'] ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'date': date?.toIso8601String(),
      };
}

class SubjectModel extends Subject {
  SubjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.maxTopics,
    required super.image,
    required super.target,
    required super.source,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      maxTopics: (json['maxTopics'] as num?)?.toInt(),
      image: json['image'],
      target: json['target'] != null
          ? SubjectTargetModel.fromJson(json['target'])
          : null,
      source:
          json['source'] != null ? SourceModel.fromJson(json['source']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'maxTopics': maxTopics,
        'image': image,
        'target':
            target == null ? null : (target as SubjectTargetModel).toJson(),
        'source': source == null ? null : (source as SourceModel).toJson(),
      };
}

class SubjectTargetModel extends SubjectTarget {
  SubjectTargetModel({
    required super.id,
    required super.name,
    required super.description,
    required super.maxTopics,
    required super.image,
  });

  factory SubjectTargetModel.fromJson(Map<String, dynamic> json) {
    return SubjectTargetModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      maxTopics: (json['maxTopics'] as num?)?.toInt(),
      image: json['image'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'maxTopics': maxTopics,
        'image': image,
      };
}

class TopicTargetModel extends TopicTarget {
  TopicTargetModel({
    required super.id,
    required super.name,
    required super.description,
    required super.subject,
  });

  factory TopicTargetModel.fromJson(Map<String, dynamic> json) {
    return TopicTargetModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      subject: json['subject'] != null
          ? SubjectModel.fromJson(json['subject'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'subject': subject == null ? null : (subject as SubjectModel).toJson(),
      };
}
