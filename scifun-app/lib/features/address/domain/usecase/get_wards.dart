import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/address_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/address/domain/repository/address_repository.dart';

class GetWards implements Usecase<List<ProvinceEntity>, int> {
  final AddressRepository repository;

  GetWards(this.repository);

  @override
  Future<Either<Failure, List<ProvinceEntity>>> call(param) async {
    return await repository.getWards(wardId: param);
  }
}
