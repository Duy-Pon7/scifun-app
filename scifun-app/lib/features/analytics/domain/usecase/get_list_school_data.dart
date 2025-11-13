import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/analytics/domain/entities/school_data_entity.dart';
import 'package:sci_fun/features/analytics/domain/repository/school_repository.dart';

class GetListSchoolData
    implements Usecase<List<SchoolDataEntity>, SchoolQueryParam> {
  final SchoolRepository schoolRepository;

  GetListSchoolData({required this.schoolRepository});

  @override
  Future<Either<Failure, List<SchoolDataEntity>>> call(
      SchoolQueryParam param) async {
    final res = await schoolRepository.getSchoolData(
      year: param.year,
      provinceId: param.provinceId,
    );
    return res;
  }
}

class SchoolQueryParam {
  final int year;
  final int provinceId;

  SchoolQueryParam({required this.year, required this.provinceId});
}
