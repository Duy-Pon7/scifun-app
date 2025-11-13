part of 'package_bloc.dart';

@immutable
sealed class PackageEvent {}

final class PackageGetSession extends PackageEvent {}
final class PackageGetInstructions extends PackageEvent {}

final class PackageBuyRequested extends PackageEvent {
  final int id;
  final File image;

  PackageBuyRequested({required this.id, required this.image});
}
