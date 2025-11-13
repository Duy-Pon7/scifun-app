import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/news_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/news_repository.dart';

class GetNewsDetail implements Usecase<NewsEntity, int> {
  final NewsRepository newsRepository;

  GetNewsDetail({required this.newsRepository});

  @override
  Future<Either<Failure, NewsEntity>> call(param) async {
    return await newsRepository.getNewsDetail(newsId: param);
  }
}
