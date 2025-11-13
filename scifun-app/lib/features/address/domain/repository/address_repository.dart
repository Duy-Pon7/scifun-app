import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/address_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';

abstract interface class AddressRepository {
  Future<Either<Failure, List<ProvinceEntity>>> getProvinces();
  Future<Either<Failure, List<ProvinceEntity>>> getWards({required int wardId});
}
