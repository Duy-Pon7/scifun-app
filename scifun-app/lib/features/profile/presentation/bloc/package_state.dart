part of 'package_bloc.dart';

@immutable
sealed class PackageState {}

final class PackageInitial extends PackageState {}

final class PackageLoading extends PackageInitial {}

final class PackageFailure extends PackageInitial {
  final String message;

  PackageFailure({required this.message});
}

final class PackageMessageSuccess extends PackageInitial {
  final String message;

  PackageMessageSuccess({required this.message});
}

final class PackageSuccess extends PackageInitial {
  final List<PackagesEntity?> package;

  PackageSuccess({required this.package});
}

final class PackageInstructionsSuccess extends PackageInitial {
  final List<InstructionsEntity?> instructions;

  PackageInstructionsSuccess({required this.instructions});
}

final class PackageBuying extends PackageInitial {}

final class PackageBuySuccess extends PackageInitial {
  final String message;

  PackageBuySuccess({required this.message});
}

final class PackageBuyFailure extends PackageInitial {
  final String message;

  PackageBuyFailure({required this.message});
}
