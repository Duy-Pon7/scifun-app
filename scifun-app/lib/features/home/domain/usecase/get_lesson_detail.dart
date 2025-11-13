import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';
import 'package:sci_fun/features/home/domain/repository/lesson_repository.dart';

class GetLessonDetail implements Usecase<LessonEntity, int> {
  final LessonRepository lessonRepository;

  GetLessonDetail({required this.lessonRepository});

  @override
  Future<Either<Failure, LessonEntity>> call(param) async {
    return await lessonRepository.getLessonDetail(lessonId: param);
  }
}
