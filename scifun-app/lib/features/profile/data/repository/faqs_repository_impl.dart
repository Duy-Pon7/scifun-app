import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/profile/data/datasource/faqs_remote_datasource.dart';
import 'package:sci_fun/features/profile/data/models/faqs_model.dart';
import 'package:sci_fun/features/profile/domain/repository/faqs_repository.dart';

class FaqsRepositoryImpl implements FaqsRepository {
  final FaqsRemoteDatasource faqsRemoteDatasource;

  FaqsRepositoryImpl({required this.faqsRemoteDatasource});

  @override
  Future<Either<Failure, List<FaqsModel>>> getFaqs() async {
    try {
      final res = await faqsRemoteDatasource.getFaqs();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
