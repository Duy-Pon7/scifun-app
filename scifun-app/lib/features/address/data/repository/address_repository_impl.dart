import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/models/province_model.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/address/data/datasource/address_remote_datasource.dart';
import 'package:sci_fun/features/address/domain/repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDatasource addressRemoteDatasource;

  AddressRepositoryImpl({required this.addressRemoteDatasource});

  @override
  Future<Either<Failure, List<ProvinceModel>>> getProvinces() async {
    try {
      final address = await addressRemoteDatasource.getProvinces();
      return Right(address);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  Future<Either<Failure, List<ProvinceModel>>> getWards(
      {required int wardId}) async {
    try {
      final address = await addressRemoteDatasource.getWards(wardId: wardId);
      return Right(address);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
