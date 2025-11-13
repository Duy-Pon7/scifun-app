import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/analytics/domain/entities/school_scores_entity.dart';
import 'package:thilop10_3004/features/analytics/domain/repository/school_repository.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

class GetListSchool
    implements
        Usecase<List<SchoolEntity>, PaginationParam<PaginationParamId<void>>> {
  final SchoolRepository schoolRepository;

  GetListSchool({required this.schoolRepository});

  @override
  Future<Either<Failure, List<SchoolEntity>>> call(
      PaginationParam<PaginationParamId<void>> params) async {
    final innerParam = params.param!;
    return await schoolRepository.getListSchool(
      page: params.page,
      provinceId: innerParam.id,
    );
  }
}
