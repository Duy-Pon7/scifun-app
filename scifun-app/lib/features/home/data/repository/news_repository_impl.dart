import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/home/data/datasource/news_remote_datasource.dart';
import 'package:thilop10_3004/features/home/domain/entity/news_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource newsRemoteDatasource;

  NewsRepositoryImpl({required this.newsRemoteDatasource});

  @override
  Future<Either<Failure, List<NewsEntity>>> getAllNews(
      {required int page}) async {
    try {
      final res = await newsRemoteDatasource.getAllNews(page: page);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, NewsEntity>> getNewsDetail(
      {required int newsId}) async {
    try {
      final res =
          await newsRemoteDatasource.getNewsDetail(newsId: newsId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
