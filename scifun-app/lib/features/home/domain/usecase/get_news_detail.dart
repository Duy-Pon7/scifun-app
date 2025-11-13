import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/news_entity.dart';
import 'package:sci_fun/features/home/domain/repository/news_repository.dart';

class GetNewsDetail implements Usecase<NewsEntity, int> {
  final NewsRepository newsRepository;

  GetNewsDetail({required this.newsRepository});

  @override
  Future<Either<Failure, NewsEntity>> call(param) async {
    return await newsRepository.getNewsDetail(newsId: param);
  }
}
