import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/faqs_entity.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';
import 'package:sci_fun/features/profile/domain/repository/faqs_repository.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';
import 'package:sci_fun/features/profile/domain/repository/faqs_repository.dart';

class GetFaqs implements Usecase<List<FaqsEntity?>, NoParams> {
  final FaqsRepository faqsRepository;

  GetFaqs({required this.faqsRepository});

  @override
  Future<Either<Failure, List<FaqsEntity?>>> call(NoParams param) async {
    return await faqsRepository.getFaqs();
  }
}
