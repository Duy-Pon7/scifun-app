import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';

abstract interface class TopicRepository {
  Future<Either<Failure, List<TopicEntity>>> getAllTopics(
    String? searchQuery, {
    required String subjectId,
    required int page,
    required int limit,
  });
}
