import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/video/data/datasource/video_remote_datasource.dart';
import 'package:sci_fun/features/video/domain/entity/video_entity.dart';
import 'package:sci_fun/features/video/domain/repository/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDatasource videoRemoteDatasource;

  VideoRepositoryImpl({required this.videoRemoteDatasource});

  @override
  Future<Either<Failure, VideoEntity>> getVideosByTopic(
    String topicId,
    int page,
    int limit,
  ) async {
    try {
      final res = await videoRemoteDatasource.getVideosByTopic(
        topicId,
        page,
        limit,
      );
      return Right(res.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
