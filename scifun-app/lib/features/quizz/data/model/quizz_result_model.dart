import 'package:sci_fun/features/quizz/domain/entity/quizz_result_entity.dart';

class QuizzResultModel extends QuizzResult {
  QuizzResultModel({
    QuizModel? quiz,
    int? score,
    String? submissionId,
    List<AnswerModel> answers = const [],
  }) : super(
          quiz: quiz,
          score: score,
          submissionId: submissionId,
          answers: answers,
        );

  factory QuizzResultModel.fromJson(Map<String, dynamic> json) {
    return QuizzResultModel(
      quiz: json['quiz'] == null ? null : QuizModel.fromJson(json['quiz']),
      score: (json['score'] as num?)?.toInt(),
      submissionId: json['submissionId'],
      answers: json['answers'] == null
          ? []
          : List<AnswerModel>.from(
              (json['answers'] as List).map((x) => AnswerModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'quiz': (quiz as QuizModel?)?.toJson(),
        'score': score,
        'submissionId': submissionId,
        'answers': answers.map((x) => (x as AnswerModel).toJson()).toList(),
      };

  factory QuizzResultModel.fromEntity(QuizzResult entity) {
    return QuizzResultModel(
      quiz: entity.quiz == null ? null : QuizModel.fromEntity(entity.quiz!),
      score: entity.score,
      submissionId: entity.submissionId,
      answers: entity.answers.map((e) => AnswerModel.fromEntity(e)).toList(),
    );
  }

  QuizzResult toEntity() {
    return QuizzResult(
      quiz: quiz,
      score: score,
      submissionId: submissionId,
      answers: answers,
    );
  }
}

class AnswerModel extends Answer {
  AnswerModel({
    String? questionId,
    List<String> selectedAnswers = const [],
    List<String> correctAnswers = const [],
    String? explanation,
    String? questionText,
    bool? isCorrect,
  }) : super(
          questionId: questionId,
          selectedAnswers: selectedAnswers,
          correctAnswers: correctAnswers,
          explanation: explanation,
          questionText: questionText,
          isCorrect: isCorrect,
        );

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        questionId: json['questionId'],
        selectedAnswers: json['selectedAnswers'] == null
            ? []
            : List<String>.from(
                (json['selectedAnswers'] as List).map((x) => x)),
        correctAnswers: json['correctAnswers'] == null
            ? []
            : List<String>.from((json['correctAnswers'] as List).map((x) => x)),
        explanation: json['explanation'],
        questionText: json['questionText'],
        isCorrect: json['isCorrect'],
      );

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'selectedAnswers': selectedAnswers,
        'correctAnswers': correctAnswers,
        'explanation': explanation,
        'questionText': questionText,
        'isCorrect': isCorrect,
      };

  factory AnswerModel.fromEntity(Answer entity) => AnswerModel(
        questionId: entity.questionId,
        selectedAnswers: entity.selectedAnswers,
        correctAnswers: entity.correctAnswers,
        explanation: entity.explanation,
        questionText: entity.questionText,
        isCorrect: entity.isCorrect,
      );

  Answer toEntity() => Answer(
        questionId: questionId,
        selectedAnswers: selectedAnswers,
        correctAnswers: correctAnswers,
        explanation: explanation,
        questionText: questionText,
        isCorrect: isCorrect,
      );
}

class QuizModel extends Quiz {
  QuizModel({
    int? duration,
    int? questionCount,
    String? accessTier,
    String? description,
    DateTime? lastAttemptAt,
    String? id,
    String? title,
    int? uniqueUserCount,
    int? favoriteCount,
  }) : super(
          duration: duration,
          questionCount: questionCount,
          accessTier: accessTier,
          description: description,
          lastAttemptAt: lastAttemptAt,
          id: id,
          title: title,
          uniqueUserCount: uniqueUserCount,
          favoriteCount: favoriteCount,
        );

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        duration: (json['duration'] as num?)?.toInt(),
        questionCount: (json['questionCount'] as num?)?.toInt(),
        accessTier: json['accessTier'],
        description: json['description'],
        lastAttemptAt: DateTime.tryParse(json['lastAttemptAt'] ?? ''),
        id: json['_id'],
        title: json['title'],
        uniqueUserCount: (json['uniqueUserCount'] as num?)?.toInt(),
        favoriteCount: (json['favoriteCount'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'questionCount': questionCount,
        'accessTier': accessTier,
        'description': description,
        'lastAttemptAt': lastAttemptAt?.toIso8601String(),
        '_id': id,
        'title': title,
        'uniqueUserCount': uniqueUserCount,
        'favoriteCount': favoriteCount,
      };

  factory QuizModel.fromEntity(Quiz entity) => QuizModel(
        duration: entity.duration,
        questionCount: entity.questionCount,
        accessTier: entity.accessTier,
        description: entity.description,
        lastAttemptAt: entity.lastAttemptAt,
        id: entity.id,
        title: entity.title,
        uniqueUserCount: entity.uniqueUserCount,
        favoriteCount: entity.favoriteCount,
      );

  Quiz toEntity() => Quiz(
        duration: duration,
        questionCount: questionCount,
        accessTier: accessTier,
        description: description,
        lastAttemptAt: lastAttemptAt,
        id: id,
        title: title,
        uniqueUserCount: uniqueUserCount,
        favoriteCount: favoriteCount,
      );
}
