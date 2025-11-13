import 'package:sci_fun/features/home/domain/entity/news_entity.dart';

class NewsModel extends NewsEntity {
  NewsModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.image,
    required super.isFeatured,
    required super.excerpt,
    required super.content,
    required super.postedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json["title"],
      slug: json["slug"],
      image: json["image"],
      isFeatured: int.tryParse(json["is_featured"].toString()),
      excerpt: json["excerpt"],
      content: json["content"],
      postedAt: DateTime.tryParse(json["posted_at"] ?? "")?.toLocal(),
    );
  }

  static List<NewsModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => NewsModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
