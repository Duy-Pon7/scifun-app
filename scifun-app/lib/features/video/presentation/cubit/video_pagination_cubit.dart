import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/video/domain/entity/video_entity.dart';
import 'package:sci_fun/features/video/domain/usecase/get_all_video.dart';

class VideoPaginationCubit extends PaginationCubit<Datum> {
  final GetAllVideos getAllVideos;

  VideoPaginationCubit(this.getAllVideos);

  @override
  Future<List<Datum>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    // filterId chứa topicId
    if (filterId == null) {
      throw Exception('Topic ID is required');
    }

    final result = await getAllVideos(
      VideoParams(
        topicId: filterId,
        page: page,
        limit: limit,
      ),
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (videoEntity) => videoEntity.data,
    );
  }
}
