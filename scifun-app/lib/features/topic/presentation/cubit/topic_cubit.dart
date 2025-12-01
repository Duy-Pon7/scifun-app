import 'package:sci_fun/common/cubit_new/pagination_cubit.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';
import 'package:sci_fun/features/topic/domain/usecase/get_all_topics.dart';

class TopicCubit extends PaginationCubit<TopicEntity> {
  final GetAllTopics getAllTopics;

  TopicCubit(this.getAllTopics);

  @override
  Future<List<TopicEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    final result = await getAllTopics.call(
      TopicsParams(
        searchQuery ?? "",
        subjectId: filterId ?? "",
        page: page,
        limit: limit,
      ),
    );

    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (list) => list,
    );
  }
}
