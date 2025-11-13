import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/profile/domain/repository/packages_repository.dart';

class BuyPackagesUseCase {
  final PackagesRepository repository;

  BuyPackagesUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required int id,
    required File image,
  }) {
    return repository.buyPackages(id: id, image: image);
  }
}
