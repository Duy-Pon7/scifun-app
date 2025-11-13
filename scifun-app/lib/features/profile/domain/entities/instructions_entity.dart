class InstructionsEntity {
  InstructionsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.position,
  });

  final int? id;
  final String? title;
  final String? content;
  final String? image;
  final String? position;
}
