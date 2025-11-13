import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/lesson_category_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/lesson_category_repository.dart';

class GetLessonCategory
    implements
        Usecase<List<LessonCategoryEntity>,
            PaginationParam<GetLessonCateParam>> {
  final LessonCategoryRepository lessonCategoryRepository;

  GetLessonCategory({required this.lessonCategoryRepository});

  @override
  Future<Either<Failure, List<LessonCategoryEntity>>> call(param) async {
    final res = await lessonCategoryRepository.getLessonCate(
        page: param.page, subjectId: param.param!.subjectId);
    return res.map((item) => item.lessonCategories);
  }
}

class GetLessonCateParam {
  final int subjectId;

  GetLessonCateParam({required this.subjectId});
}
