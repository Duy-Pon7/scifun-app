class AnswerEntity {
  final int? id;
  final String? label;
  final String? answer;
  final String? type;
  final bool? isCorrect;
  final String? group;

  AnswerEntity({
    required this.id,
    required this.label,
    required this.answer,
    required this.type,
    required this.isCorrect,
    required this.group,
  });
}
