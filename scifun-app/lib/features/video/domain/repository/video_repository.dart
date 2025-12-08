import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/video/domain/entity/video_entity.dart';

abstract interface class VideoRepository {
  Future<Either<Failure, VideoEntity>> getVideosByTopic(
    String topicId,
    int page,
    int limit,
  );
}
