class FaqsEntity {
  FaqsEntity({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
  });

  final int? id;
  final String? question;
  final String? answer;
  final String? status;
}
