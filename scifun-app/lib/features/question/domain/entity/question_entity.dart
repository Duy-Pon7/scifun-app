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

  @override
  List<Object?> get props => [total, data, limit, totalPages, page];
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

  @override
  List<Object?> get props => [quiz, answers, id, text, explanation];
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

  @override
  List<Object?> get props => [id, text, isCorrect];
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
