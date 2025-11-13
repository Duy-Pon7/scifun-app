import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/home/domain/repository/quizz_repository.dart';

class GetQuizzDetail implements Usecase<QuizzEntity, int> {
  final QuizzRepository quizzRepository;

  GetQuizzDetail({required this.quizzRepository});

  @override
  Future<Either<Failure, QuizzEntity>> call(param) async {
    return await quizzRepository.getQuizzDetail(quizzId: param);
  }
}
