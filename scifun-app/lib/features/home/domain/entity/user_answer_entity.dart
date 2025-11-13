class UserAnswerEntity {
  final int? questionId;
  final String? question;
  final List<int>? userAnswerIds;
  final bool? isCorrect;
  final String? textAnswer;

  UserAnswerEntity({
    required this.questionId,
    required this.question,
    required this.userAnswerIds,
    required this.isCorrect,
    required this.textAnswer,
  });
}
