import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/Topic/domain/repository/Topic_repository.dart';
import 'package:sci_fun/features/topic/data/datasource/topic_remote_datasource.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';

class TopicRepositoryImpl implements TopicRepository {
  final TopicRemoteDatasource topicRemoteDatasource;

  TopicRepositoryImpl({required this.topicRemoteDatasource});

  @override
  Future<Either<Failure, List<TopicEntity>>> getAllTopics(
    String? searchQuery, {
    required String subjectId,
    required int page,
    required int limit,
  }) async {
    try {
      final res = await topicRemoteDatasource.getAllTopics(
        searchQuery,
        subjectId: subjectId,
        page: page,
        limit: limit,
      );
      // Chuyển đổi List<TopicModel> sang List<TopicEntity> nếu cần
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
