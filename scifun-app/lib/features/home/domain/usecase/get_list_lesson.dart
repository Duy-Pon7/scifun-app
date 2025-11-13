import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';
import 'package:sci_fun/features/home/domain/repository/lesson_repository.dart';

class GetListLesson
    implements Usecase<List<LessonEntity>, PaginationParam<int>> {
  final LessonRepository lessonRepository;

  GetListLesson({required this.lessonRepository});

  @override
  Future<Either<Failure, List<LessonEntity>>> call(
      PaginationParam<int> param) async {
    final res = await lessonRepository.getListLesson(
        page: param.page, lessonCategoryId: param.param);
    return res.map((item) => item.lessons ?? []);
  }
}
