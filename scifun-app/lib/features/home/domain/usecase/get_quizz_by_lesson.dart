import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/quizz_repository.dart';

class GetQuizzByLesson
    implements Usecase<List<QuizzEntity>, PaginationParam<int>> {
  final QuizzRepository quizzRepository;

  GetQuizzByLesson({required this.quizzRepository});

  @override
  Future<Either<Failure, List<QuizzEntity>>> call(
      PaginationParam<int> param) async {
    final res = await quizzRepository.getQuizzByLesson(
        page: param.page, lessonId: param.param!);
    return res.map((item) => item.quizzes ?? []);
  }
}
