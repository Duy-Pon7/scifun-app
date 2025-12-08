import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/video/domain/entity/video_entity.dart';
import 'package:sci_fun/features/video/domain/repository/video_repository.dart';

class GetAllVideos implements Usecase<VideoEntity, VideoParams> {
  final VideoRepository videoRepository;

  GetAllVideos({required this.videoRepository});

  @override
  Future<Either<Failure, VideoEntity>> call(VideoParams params) async {
    return await videoRepository.getVideosByTopic(
      params.topicId,
      params.page,
      params.limit,
    );
  }
}

class VideoParams {
  final String topicId;
  final int page;
  final int limit;

  VideoParams({
    required this.topicId,
    this.page = 1,
    this.limit = 10,
  });
}
