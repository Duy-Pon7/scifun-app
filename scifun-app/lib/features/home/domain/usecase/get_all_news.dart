  import 'package:dartz/dartz.dart';
  import 'package:thilop10_3004/core/error/failure.dart';
  import 'package:thilop10_3004/core/utils/usecase.dart';
  import 'package:thilop10_3004/features/home/domain/entity/news_entity.dart';
  import 'package:thilop10_3004/features/home/domain/repository/news_repository.dart';

  class GetAllNews
      implements Usecase<List<NewsEntity>, PaginationParam<void>> {
    final NewsRepository newsRepository;
    GetAllNews({required this.newsRepository});

    @override
    Future<Either<Failure, List<NewsEntity>>> call(
        PaginationParam<void> param) async {
      final res = await newsRepository.getAllNews(page: param.page);
      // Giả sử res là ResponseNewsEntity
      return res.map((response) => response);
    }
  }

