import 'package:equatable/equatable.dart';

class QuizzResult extends Equatable {
  QuizzResult({
    required this.quiz,
    required this.score,
    required this.submissionId,
    required this.answers,
  });

  final Quiz? quiz;
  final int? score;
  final String? submissionId;
  final List<Answer> answers;

  QuizzResult copyWith({
    Quiz? quiz,
    int? score,
    String? submissionId,
    List<Answer>? answers,
  }) {
    return QuizzResult(
      quiz: quiz ?? this.quiz,
      score: score ?? this.score,
      submissionId: submissionId ?? this.submissionId,
      answers: answers ?? this.answers,
    );
  }

  factory QuizzResult.fromJson(Map<String, dynamic> json) {
    return QuizzResult(
      quiz: json["quiz"] == null ? null : Quiz.fromJson(json["quiz"]),
      score: json["score"],
      submissionId: json["submissionId"],
      answers: json["answers"] == null
          ? []
          : List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "quiz": quiz?.toJson(),
        "score": score,
        "submissionId": submissionId,
        "answers": answers.map((x) => x?.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        quiz,
        score,
        submissionId,
        answers,
      ];
}

class Answer extends Equatable {
  Answer({
    required this.questionId,
    required this.selectedAnswers,
    required this.correctAnswers,
    required this.explanation,
    required this.questionText,
    required this.isCorrect,
  });

  final String? questionId;
  final List<String> selectedAnswers;
  final List<String> correctAnswers;
  final String? explanation;
  final String? questionText;
  final bool? isCorrect;

  Answer copyWith({
    String? questionId,
    List<String>? selectedAnswers,
    List<String>? correctAnswers,
    String? explanation,
    String? questionText,
    bool? isCorrect,
  }) {
    return Answer(
      questionId: questionId ?? this.questionId,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      explanation: explanation ?? this.explanation,
      questionText: questionText ?? this.questionText,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json["questionId"],
      selectedAnswers: json["selectedAnswers"] == null
          ? []
          : List<String>.from(json["selectedAnswers"]!.map((x) => x)),
      correctAnswers: json["correctAnswers"] == null
          ? []
          : List<String>.from(json["correctAnswers"]!.map((x) => x)),
      explanation: json["explanation"],
      questionText: json["questionText"],
      isCorrect: json["isCorrect"],
    );
  }

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "selectedAnswers": selectedAnswers.map((x) => x).toList(),
        "correctAnswers": correctAnswers.map((x) => x).toList(),
        "explanation": explanation,
        "questionText": questionText,
        "isCorrect": isCorrect,
      };

  @override
  List<Object?> get props => [
        questionId,
        selectedAnswers,
        correctAnswers,
        explanation,
        questionText,
        isCorrect,
      ];
}

class Quiz extends Equatable {
  Quiz({
    required this.duration,
    required this.questionCount,
    required this.accessTier,
    required this.description,
    required this.lastAttemptAt,
    required this.id,
    required this.title,
    required this.uniqueUserCount,
    required this.favoriteCount,
  });

  final int? duration;
  final int? questionCount;
  final String? accessTier;
  final String? description;
  final DateTime? lastAttemptAt;
  final String? id;
  final String? title;
  final int? uniqueUserCount;
  final int? favoriteCount;

  Quiz copyWith({
    int? duration,
    int? questionCount,
    String? accessTier,
    String? description,
    DateTime? lastAttemptAt,
    String? id,
    String? title,
    int? uniqueUserCount,
    int? favoriteCount,
  }) {
    return Quiz(
      duration: duration ?? this.duration,
      questionCount: questionCount ?? this.questionCount,
      accessTier: accessTier ?? this.accessTier,
      description: description ?? this.description,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      id: id ?? this.id,
      title: title ?? this.title,
      uniqueUserCount: uniqueUserCount ?? this.uniqueUserCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      duration: json["duration"],
      questionCount: json["questionCount"],
      accessTier: json["accessTier"],
      description: json["description"],
      lastAttemptAt: DateTime.tryParse(json["lastAttemptAt"] ?? ""),
      id: json["_id"],
      title: json["title"],
      uniqueUserCount: json["uniqueUserCount"],
      favoriteCount: json["favoriteCount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "questionCount": questionCount,
        "accessTier": accessTier,
        "description": description,
        "lastAttemptAt": lastAttemptAt?.toIso8601String(),
        "_id": id,
        "title": title,
        "uniqueUserCount": uniqueUserCount,
        "favoriteCount": favoriteCount,
      };

  @override
  List<Object?> get props => [
        duration,
        questionCount,
        accessTier,
        description,
        lastAttemptAt,
        id,
        title,
        uniqueUserCount,
        favoriteCount,
      ];
}
