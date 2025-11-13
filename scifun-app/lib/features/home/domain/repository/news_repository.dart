import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/home/domain/entity/news_entity.dart';

abstract interface class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getAllNews(
      {required int page});
  Future<Either<Failure, NewsEntity>> getNewsDetail({
    required int newsId,
  });
}
