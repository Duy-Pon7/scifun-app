import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';

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
