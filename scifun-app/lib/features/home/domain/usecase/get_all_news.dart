import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/news_entity.dart';
import 'package:sci_fun/features/home/domain/repository/news_repository.dart';

class GetAllNews implements Usecase<List<NewsEntity>, PaginationParam<void>> {
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
