import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/address_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/address/domain/repository/address_repository.dart';

class GetWards implements Usecase<List<ProvinceEntity>, int> {
  final AddressRepository repository;

  GetWards(this.repository);

  @override
  Future<Either<Failure, List<ProvinceEntity>>> call(param) async {
    return await repository.getWards(wardId: param);
  }
}
