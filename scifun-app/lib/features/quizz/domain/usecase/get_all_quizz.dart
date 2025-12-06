import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/quizz/domain/repository/quizz_repository.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';

class GetAllQuizzes implements Usecase<List<QuizzEntity>, QuizzParams> {
  final QuizzRepository quizzRepository;

  GetAllQuizzes({required this.quizzRepository});

  @override
  Future<Either<Failure, List<QuizzEntity>>> call(QuizzParams params) async {
    return await quizzRepository.getAllQuizzes(
      params.searchQuery,
      topicId: params.topicId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class QuizzParams {
  final String? searchQuery;
  final String topicId;
  final int page;
  final int limit;

  QuizzParams(
    this.searchQuery, {
    required this.topicId,
    required this.page,
    required this.limit,
  });
}
