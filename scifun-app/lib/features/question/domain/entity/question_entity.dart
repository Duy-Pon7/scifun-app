import 'package:equatable/equatable.dart';

class QuestionsResponseEntity extends Equatable {
  const QuestionsResponseEntity({
    required this.total,
    required this.data,
    required this.limit,
    required this.totalPages,
    required this.page,
  });

  final int? total;
  final List<QuestionEntity> data;
  final int? limit;
  final int? totalPages;
  final int? page;

  QuestionsResponseEntity copyWith({
    int? total,
    List<QuestionEntity>? data,
    int? limit,
    int? totalPages,
    int? page,
  }) {
    return QuestionsResponseEntity(
      total: total ?? this.total,
      data: data ?? this.data,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
    );
  }

  factory QuestionsResponseEntity.fromJson(Map<String, dynamic> json) {
    return QuestionsResponseEntity(
      total: json["total"],
      data: json["data"] == null
          ? []
          : List<QuestionEntity>.from(
              json["data"]!.map((x) => QuestionEntity.fromJson(x))),
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

  @override
  List<Object?> get props => [
        total,
        data,
        limit,
        totalPages,
        page,
      ];
}

class QuestionEntity extends Equatable {
  const QuestionEntity({
    required this.quiz,
    required this.answers,
    required this.id,
    required this.text,
    required this.explanation,
  });

  final QuizEntity? quiz;
  final List<AnswerEntity> answers;
  final String? id;
  final String? text;
  final String? explanation;

  QuestionEntity copyWith({
    QuizEntity? quiz,
    List<AnswerEntity>? answers,
    String? id,
    String? text,
    String? explanation,
  }) {
    return QuestionEntity(
      quiz: quiz ?? this.quiz,
      answers: answers ?? this.answers,
      id: id ?? this.id,
      text: text ?? this.text,
      explanation: explanation ?? this.explanation,
    );
  }

  factory QuestionEntity.fromJson(Map<String, dynamic> json) {
    return QuestionEntity(
      quiz: json["quiz"] == null ? null : QuizEntity.fromJson(json["quiz"]),
      answers: json["answers"] == null
          ? []
          : List<AnswerEntity>.from(
              json["answers"]!.map((x) => AnswerEntity.fromJson(x))),
      id: json["_id"],
      text: json["text"],
      explanation: json["explanation"],
    );
  }

  Map<String, dynamic> toJson() => {
        "quiz": quiz?.toJson(),
        "answers": answers.map((x) => x.toJson()).toList(),
        "_id": id,
        "text": text,
        "explanation": explanation,
      };

  @override
  List<Object?> get props => [
        quiz,
        answers,
        id,
        text,
        explanation,
      ];
}

class DatumEntity extends Equatable {
  const DatumEntity({
    required this.quiz,
    required this.answers,
    required this.id,
    required this.text,
    required this.explanation,
  });

  final QuizEntity? quiz;
  final List<AnswerEntity> answers;
  final String? id;
  final String? text;
  final String? explanation;

  DatumEntity copyWith({
    QuizEntity? quiz,
    List<AnswerEntity>? answers,
    String? id,
    String? text,
    String? explanation,
  }) {
    return DatumEntity(
      quiz: quiz ?? this.quiz,
      answers: answers ?? this.answers,
      id: id ?? this.id,
      text: text ?? this.text,
      explanation: explanation ?? this.explanation,
    );
  }

  factory DatumEntity.fromJson(Map<String, dynamic> json) {
    return DatumEntity(
      quiz: json["quiz"] == null ? null : QuizEntity.fromJson(json["quiz"]),
      answers: json["answers"] == null
          ? []
          : List<AnswerEntity>.from(
              json["answers"]!.map((x) => AnswerEntity.fromJson(x))),
      id: json["_id"],
      text: json["text"],
      explanation: json["explanation"],
    );
  }

  Map<String, dynamic> toJson() => {
        "quiz": quiz?.toJson(),
        "answers": answers.map((x) => x.toJson()).toList(),
        "_id": id,
        "text": text,
        "explanation": explanation,
      };

  @override
  List<Object?> get props => [
        quiz,
        answers,
        id,
        text,
        explanation,
      ];
}

class AnswerEntity extends Equatable {
  const AnswerEntity({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  final String? id;
  final String? text;
  final bool? isCorrect;

  AnswerEntity copyWith({
    String? id,
    String? text,
    bool? isCorrect,
  }) {
    return AnswerEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  factory AnswerEntity.fromJson(Map<String, dynamic> json) {
    return AnswerEntity(
      id: json["_id"],
      text: json["text"],
      isCorrect: json["isCorrect"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "isCorrect": isCorrect,
      };

  @override
  List<Object?> get props => [
        id,
        text,
        isCorrect,
      ];
}

class QuizEntity extends Equatable {
  const QuizEntity({
    required this.questionCount,
    required this.accessTier,
    required this.description,
    required this.lastAttemptAt,
    required this.title,
    required this.uniqueUserCount,
    required this.duration,
    required this.createdAt,
    required this.isLocked,
    required this.topic,
    required this.id,
    required this.favoriteCount,
    required this.updatedAt,
  });

  final int? questionCount;
  final String? accessTier;
  final String? description;
  final DateTime? lastAttemptAt;
  final String? title;
  final int? uniqueUserCount;
  final int? duration;
  final DateTime? createdAt;
  final bool? isLocked;
  final String? topic;
  final String? id;
  final int? favoriteCount;
  final DateTime? updatedAt;

  QuizEntity copyWith({
    int? questionCount,
    String? accessTier,
    String? description,
    DateTime? lastAttemptAt,
    String? title,
    int? uniqueUserCount,
    int? duration,
    DateTime? createdAt,
    bool? isLocked,
    String? topic,
    String? id,
    int? favoriteCount,
    DateTime? updatedAt,
  }) {
    return QuizEntity(
      questionCount: questionCount ?? this.questionCount,
      accessTier: accessTier ?? this.accessTier,
      description: description ?? this.description,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      title: title ?? this.title,
      uniqueUserCount: uniqueUserCount ?? this.uniqueUserCount,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      isLocked: isLocked ?? this.isLocked,
      topic: topic ?? this.topic,
      id: id ?? this.id,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory QuizEntity.fromJson(Map<String, dynamic> json) {
    return QuizEntity(
      questionCount: json["questionCount"],
      accessTier: json["accessTier"],
      description: json["description"],
      lastAttemptAt: DateTime.tryParse(json["lastAttemptAt"] ?? ""),
      title: json["title"],
      uniqueUserCount: json["uniqueUserCount"],
      duration: json["duration"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      isLocked: json["isLocked"],
      topic: json["topic"],
      id: json["_id"],
      favoriteCount: json["favoriteCount"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "questionCount": questionCount,
        "accessTier": accessTier,
        "description": description,
        "lastAttemptAt": lastAttemptAt?.toIso8601String(),
        "title": title,
        "uniqueUserCount": uniqueUserCount,
        "duration": duration,
        "createdAt": createdAt?.toIso8601String(),
        "isLocked": isLocked,
        "topic": topic,
        "_id": id,
        "favoriteCount": favoriteCount,
        "updatedAt": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        questionCount,
        accessTier,
        description,
        lastAttemptAt,
        title,
        uniqueUserCount,
        duration,
        createdAt,
        isLocked,
        topic,
        id,
        favoriteCount,
        updatedAt,
      ];
}
