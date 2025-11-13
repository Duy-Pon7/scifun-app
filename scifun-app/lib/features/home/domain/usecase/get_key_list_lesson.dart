import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';
import 'package:sci_fun/features/home/domain/repository/lesson_repository.dart';

class GetKeyListLesson
    implements Usecase<List<LessonEntity>, PaginationParam<String>> {
  final LessonRepository lessonRepository;

  GetKeyListLesson({required this.lessonRepository});

  @override
  Future<Either<Failure, List<LessonEntity>>> call(
      PaginationParam<String> param) async {
    final res = await lessonRepository.getListLesson(
        page: param.page, keyWord: param.param);
    return res.map((item) => item.lessons ?? []);
  }
}
