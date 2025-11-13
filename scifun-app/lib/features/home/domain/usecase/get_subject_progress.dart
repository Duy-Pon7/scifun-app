import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/response_progress_entity.dart';
import 'package:sci_fun/features/home/domain/repository/lesson_repository.dart';

class GetSubjectProgress
    implements Usecase<ResponseProgressEntity, PaginationParam<int>> {
  final LessonRepository lessonRepository;

  GetSubjectProgress({required this.lessonRepository});

  @override
  Future<Either<Failure, ResponseProgressEntity>> call(
      PaginationParam<int> param) async {
    final res = await lessonRepository.getListSubject(
      page: param.page,
      subjectId: param.param!,
    );
    return res.map((response) => response);
  }
}
