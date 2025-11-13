import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/profile/domain/entities/instructions_entity.dart';
import 'package:thilop10_3004/features/profile/domain/repository/packages_repository.dart';

class GetInstructions implements Usecase<List<InstructionsEntity?>, NoParams> {
  final PackagesRepository packagesRepository;

  GetInstructions({required this.packagesRepository});

  @override
  Future<Either<Failure, List<InstructionsEntity?>>> call(
      NoParams param) async {
    return await packagesRepository.getInstructions();
  }
}
