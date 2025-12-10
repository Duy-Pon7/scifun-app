import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/quizz/domain/repository/quizz_repository.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';

class GetTrendQuizzes implements Usecase<List<QuizzEntity>, NoParams> {
  final QuizzRepository quizzRepository;

  GetTrendQuizzes({required this.quizzRepository});

  @override
  Future<Either<Failure, List<QuizzEntity>>> call(NoParams params) async {
    return await quizzRepository.getTrendQuizzes();
  }
}
