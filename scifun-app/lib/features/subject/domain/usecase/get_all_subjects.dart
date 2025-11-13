import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/subject/domain/entity/subject_entity.dart';
import 'package:thilop10_3004/features/subject/domain/repository/subject_repository.dart';

class GetAllSubjects implements Usecase<SubjectEntity, NoParams> {
  final SubjectRepository subjectRepository;

  GetAllSubjects({required this.subjectRepository});

  @override
  Future<Either<Failure, SubjectEntity>> call(param) async {
    return await subjectRepository.getAllSubjects();
  }
}
