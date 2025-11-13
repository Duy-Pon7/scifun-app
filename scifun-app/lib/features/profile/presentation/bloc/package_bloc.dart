import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/instructions_entity.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';
import 'package:sci_fun/features/profile/domain/usecase/buy_packages.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_instructions.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_packages.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final GetPackages _getPackage;
  final GetInstructions _getInstructions;
  final BuyPackagesUseCase _buyPackages;
  PackageBloc({
    required GetPackages getPackage,
    required GetInstructions getInstructions,
    required BuyPackagesUseCase buyPackages,
  })  : _getPackage = getPackage,
        _getInstructions = getInstructions,
        _buyPackages = buyPackages,
        super(PackageInitial()) {
    on<PackageGetSession>(_onPackageGetSession);
    on<PackageBuyRequested>(_onPackageBuyRequested);
    on<PackageGetInstructions>(_onPackageGetInstructions);
  }

  void _onPackageGetSession(
      PackageEvent event, Emitter<PackageState> emit) async {
    final res = await _getPackage.call(NoParams());
    res.fold(
      (failure) => emit(PackageFailure(message: failure.message)),
      (package) => emit(PackageSuccess(package: package)),
    );
  }

  void _onPackageGetInstructions(
      PackageEvent event, Emitter<PackageState> emit) async {
    final res = await _getInstructions.call(NoParams());
    res.fold(
      (failure) => emit(PackageFailure(message: failure.message)),
      (instructions) =>
          emit(PackageInstructionsSuccess(instructions: instructions)),
    );
  }

  void _onPackageBuyRequested(
      PackageBuyRequested event, Emitter<PackageState> emit) async {
    emit(PackageBuying());

    final result = await _buyPackages.call(id: event.id, image: event.image);

    result.fold(
      (failure) => emit(PackageBuyFailure(message: failure.message)),
      (_) => emit(PackageBuySuccess(message: 'Mua gói thành công')),
    );
  }
}
