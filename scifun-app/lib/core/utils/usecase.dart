import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';

abstract interface class Usecase<Type, Param> {
  Future<Either<Failure, Type>> call(Param param);
}

class NoParams {}

// class PaginationParam<Type> {
//   final int page;
//   final Type? param;

//   PaginationParam({required this.page, this.param});

//   PaginationParam<Type> copyWith({
//     int? newPage,
//     Type? newParam,
//   }) {
//     return PaginationParam<Type>(
// =======
class PaginationParam<T> {
  final int page;
  final T? param;

  PaginationParam({required this.page, this.param});

  PaginationParam<T> copyWith({
    int? newPage,
    T? newParam,
    String? newKeyWord,
  }) {
    return PaginationParam<T>(
      page: newPage ?? page,
      param: newParam ?? param,
    );
  }
}

class PaginationParamId<T> {
  final int page;
  final int id; // Add this line if you need an id
  final T? param;

  PaginationParamId({required this.page, required this.id, this.param});

  PaginationParamId<T> copyWith({
    int? newPage,
    int? newId,
    T? newParam,
  }) {
    return PaginationParamId<T>(
      page: newPage ?? page,
      id: newId ?? id,
      param: newParam ?? param,
    );
  }
}
