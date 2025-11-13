import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/domain/repository/subject_repository.dart';

class GetAllSubjects implements Usecase<SubjectEntity, NoParams> {
  final SubjectRepository subjectRepository;

  GetAllSubjects({required this.subjectRepository});

  @override
  Future<Either<Failure, SubjectEntity>> call(param) async {
    return await subjectRepository.getAllSubjects();
  }
}
