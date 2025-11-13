import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';

class GetPackages implements Usecase<List<PackagesEntity?>, NoParams> {
  final PackagesRepository packagesRepository;

  GetPackages({required this.packagesRepository});

  @override
  Future<Either<Failure, List<PackagesEntity?>>> call(NoParams param) async {
    return await packagesRepository.getPackages();
  }
}
