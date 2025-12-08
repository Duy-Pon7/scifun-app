import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/Topic/domain/repository/Topic_repository.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';

class GetAllTopics implements Usecase<List<TopicEntity>, TopicsParams> {
  final TopicRepository topicRepository;

  GetAllTopics({required this.topicRepository});

  @override
  Future<Either<Failure, List<TopicEntity>>> call(TopicsParams params) async {
    return await topicRepository.getAllTopics(
      params.searchQuery,
      subjectId: params.subjectId ??
          '', // Default to an empty string if subjectId is null
      page: params.page,
      limit: params.limit,
    );
  }
}

class TopicsParams {
  final String? searchQuery;
  final String? subjectId;
  final int page;
  final int limit;

  TopicsParams(
    this.searchQuery,
    this.subjectId, {
    required this.page,
    required this.limit,
  });
}
