import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/quizz/domain/repository/quizz_repository.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_trend_entity.dart';

class GetTrendQuizzes implements Usecase<QuizzTrend, TrendQuizzParams> {
  final QuizzRepository quizzRepository;

  GetTrendQuizzes({required this.quizzRepository});

  @override
  Future<Either<Failure, QuizzTrend>> call(TrendQuizzParams params) async {
    return await quizzRepository.getTrendQuizzes(subjectId: params.subjectId);
  }
}

class TrendQuizzParams {
  final String? subjectId;

  TrendQuizzParams({this.subjectId});
}
