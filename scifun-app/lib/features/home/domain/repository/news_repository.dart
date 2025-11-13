import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/home/domain/entity/news_entity.dart';

abstract interface class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getAllNews({required int page});
  Future<Either<Failure, NewsEntity>> getNewsDetail({
    required int newsId,
  });
}
