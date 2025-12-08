import 'package:sci_fun/features/question/domain/entity/question_entity.dart';

class QuestionsResponseModel extends QuestionsResponseEntity {
  const QuestionsResponseModel({
    required super.total,
    required super.data,
    required super.limit,
    required super.totalPages,
    required super.page,
  });

  factory QuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return QuestionsResponseModel(
      total: json["total"],
      data: json["data"] == null
          ? []
          : List<QuestionEntity>.from(
              json["data"]!.map((x) => DatumModel.fromJson(x))),
      limit: json["limit"],
      totalPages: json["totalPages"],
      page: json["page"],
    );
  }

  @override
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

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.quiz,
    required super.answers,
    required super.id,
    required super.text,
    required super.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      quiz: json["quiz"] == null ? null : QuizModel.fromJson(json["quiz"]),
      answers: json["answers"] == null
          ? []
          : List<AnswerModel>.from(
              json["answers"]!.map((x) => AnswerModel.fromJson(x))),
      id: json["_id"],
      text: json["text"],
      explanation: json["explanation"],
    );
  }

  @override
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

class DatumModel extends DatumEntity {
  const DatumModel({
    required super.quiz,
    required super.answers,
    required super.id,
    required super.text,
    required super.explanation,
  });

  factory DatumModel.fromJson(Map<String, dynamic> json) {
    return DatumModel(
      quiz: json["quiz"] == null ? null : QuizModel.fromJson(json["quiz"]),
      answers: json["answers"] == null
          ? []
          : List<AnswerModel>.from(
              json["answers"]!.map((x) => AnswerModel.fromJson(x))),
      id: json["_id"],
      text: json["text"],
      explanation: json["explanation"],
    );
  }

  @override
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

class AnswerModel extends AnswerEntity {
  const AnswerModel({
    required super.id,
    required super.text,
    required super.isCorrect,
  });

  @override
  AnswerModel copyWith({
    String? id,
    String? text,
    bool? isCorrect,
  }) {
    return AnswerModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json["_id"],
      text: json["text"],
      isCorrect: json["isCorrect"],
    );
  }

  @override
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

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.questionCount,
    required super.accessTier,
    required super.description,
    required super.lastAttemptAt,
    required super.title,
    required super.uniqueUserCount,
    required super.duration,
    required super.createdAt,
    required super.isLocked,
    required super.topic,
    required super.id,
    required super.favoriteCount,
    required super.updatedAt,
  });

  @override
  QuizModel copyWith({
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
    return QuizModel(
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

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
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

  @override
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
