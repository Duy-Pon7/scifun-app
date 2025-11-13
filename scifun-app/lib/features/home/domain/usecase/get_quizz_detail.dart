import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/quizz_repository.dart';

class GetQuizzDetail implements Usecase<QuizzEntity, int>{
  final QuizzRepository quizzRepository;

  GetQuizzDetail({required this.quizzRepository});

  @override
  Future<Either<Failure, QuizzEntity>> call(param) async {
    return await quizzRepository.getQuizzDetail(quizzId: param);
  }
}