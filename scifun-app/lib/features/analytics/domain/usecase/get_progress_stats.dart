import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_stats_entity.dart';
import 'package:sci_fun/features/analytics/domain/repository/progress_stats_repository.dart';

class GetProgressStats implements Usecase<ProgressStatsEntity, NoParams> {
  GetProgressStats({required this.progressStatsRepository});

  final ProgressStatsRepository progressStatsRepository;

  @override
  Future<Either<Failure, ProgressStatsEntity>> call(NoParams params) async {
    return progressStatsRepository.getProgressStats();
  }
}
