import '../../domain/entity/question_entity.dart';

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
      total: json['total'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
      limit: json['limit'],
      totalPages: json['totalPages'],
      page: json['page'],
    );
  }
}

/// =======================
/// QUESTION MODEL
/// =======================
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
      quiz: json['quiz'] == null ? null : QuizModel.fromJson(json['quiz']),
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((e) => AnswerModel.fromJson(e))
          .toList(),
      id: json['_id'],
      text: json['text'],
      explanation: json['explanation'],
    );
  }
}

/// =======================
/// ANSWER MODEL
/// =======================
class AnswerModel extends AnswerEntity {
  const AnswerModel({
    required super.id,
    required super.text,
    required super.isCorrect,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['_id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
    );
  }
}

/// =======================
/// QUIZ MODEL
/// =======================
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

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      questionCount: json['questionCount'],
      accessTier: json['accessTier'],
      description: json['description'],
      lastAttemptAt: DateTime.tryParse(json['lastAttemptAt'] ?? ''),
      title: json['title'],
      uniqueUserCount: json['uniqueUserCount'],
      duration: json['duration'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      isLocked: json['isLocked'],
      topic: json['topic'],
      id: json['_id'],
      favoriteCount: json['favoriteCount'],
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
}
