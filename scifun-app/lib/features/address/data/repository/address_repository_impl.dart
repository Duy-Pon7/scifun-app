import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/models/province_model.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/address/data/datasource/address_remote_datasource.dart';
import 'package:thilop10_3004/features/address/domain/repository/address_repository.dart';

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
