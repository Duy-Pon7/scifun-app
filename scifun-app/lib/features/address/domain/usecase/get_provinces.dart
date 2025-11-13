import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/address_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/address/domain/repository/address_repository.dart';

class GetProvinces implements Usecase<List<ProvinceEntity>, NoParams> {
  final AddressRepository repository;

  GetProvinces(this.repository);

  @override
  Future<Either<Failure, List<ProvinceEntity>>> call(NoParams params) async {
    return await repository.getProvinces();
  }
}
