class NewsEntity {
  final int? id;
  final String? title;
  final String? slug;
  final String? image;
  final int? isFeatured;
  final String? excerpt;
  final String? content;
  final DateTime? postedAt;

  NewsEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.isFeatured,
    required this.excerpt,
    required this.content,
    required this.postedAt,
  });
}
