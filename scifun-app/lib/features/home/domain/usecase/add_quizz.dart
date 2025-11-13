import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/home/domain/repository/quizz_repository.dart';

class AddQuizz implements Usecase<QuizzEntity, Map<String, dynamic>> {
  final QuizzRepository quizzRepository;

  AddQuizz({required this.quizzRepository});

  @override
  Future<Either<Failure, QuizzEntity>> call(param) async {
    return await quizzRepository.addQuizz(quizzParam: param);
  }
}
