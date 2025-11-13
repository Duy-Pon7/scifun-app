import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/address_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/address/domain/repository/address_repository.dart';

class GetProvinces implements Usecase<List<ProvinceEntity>, NoParams> {
  final AddressRepository repository;

  GetProvinces(this.repository);

  @override
  Future<Either<Failure, List<ProvinceEntity>>> call(NoParams params) async {
    return await repository.getProvinces();
  }
}
