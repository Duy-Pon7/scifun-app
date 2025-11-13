import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/address_entity.dart';
import 'package:sci_fun/core/error/failure.dart';

abstract interface class AddressRepository {
  Future<Either<Failure, List<ProvinceEntity>>> getProvinces();
  Future<Either<Failure, List<ProvinceEntity>>> getWards({required int wardId});
}
