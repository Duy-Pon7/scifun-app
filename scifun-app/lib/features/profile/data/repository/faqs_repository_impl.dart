import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/profile/data/datasource/faqs_remote_datasource.dart';
import 'package:thilop10_3004/features/profile/data/models/faqs_model.dart';
import 'package:thilop10_3004/features/profile/domain/repository/faqs_repository.dart';

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
