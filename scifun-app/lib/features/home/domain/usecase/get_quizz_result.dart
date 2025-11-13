import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_result_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/quizz_repository.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

class GetQuizzResult
    implements
        Usecase<List<QuizzResultEntity>,
            PaginationParam<PaginationParamId<void>>> {
  final QuizzRepository quizzRepository;

  GetQuizzResult({required this.quizzRepository});

  @override
  Future<Either<Failure, List<QuizzResultEntity>>> call(
      PaginationParam<PaginationParamId<void>> params) async {
    final innerParam = params.param!;
    return await quizzRepository.getQuizzResult(
      page: params.page,
      quizzId: innerParam.id,
    );
  }
}
