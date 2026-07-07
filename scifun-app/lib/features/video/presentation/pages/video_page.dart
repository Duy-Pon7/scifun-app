import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/helper/youtube_helper.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/quizz/presentation/pages/quizz_page.dart';
import 'package:sci_fun/features/video/domain/entity/video_entity.dart';
import 'package:sci_fun/features/video/presentation/cubit/video_pagination_cubit.dart';
import 'package:sci_fun/features/video/presentation/pages/youtube_page.dart';

class VideoPage extends StatefulWidget {
  final String topicId;
  final String topicName;

  const VideoPage({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPaginationCubit _videoPaginationCubit;

  @override
  void initState() {
    super.initState();
    _videoPaginationCubit = sl<VideoPaginationCubit>();
    _videoPaginationCubit.loadInitial(filterId: widget.topicId);
  }

  @override
  void dispose() {
    _videoPaginationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Lý thuyết - ${widget.topicName}",
        ),
        body: PaginationListView<Datum>(
          cubit: _videoPaginationCubit,
          itemBuilder: (context, video) {
            return VideoTile(video: video);
          },
          emptyWidget: const Center(
            child: AppEmptyState(message: 'Chưa có video nào'),
          ),
          errorWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.error_outline_rounded,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Lỗi khi tải video',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.red[600],
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    _videoPaginationCubit.refresh();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.w),
          child: BasicButton(
            text: 'Bài tập tự luyện',
            width: double.infinity,
            height: 48.h,
            borderRadius: BorderRadius.circular(8.r),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: QuizzPage(
                      topicId: widget.topicId,
                      topicName: widget.topicName,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final Datum video;

  const VideoTile({
    super.key,
    required this.video,
  });

  String? get _thumbnailUrl {
    final url = video.url;
    if (url == null || url.isEmpty) {
      return null;
    }

    return YoutubeHelper.buildThumbnailUrl(url);
  }

  Widget _buildThumbnail() {
    final thumbnailUrl = _thumbnailUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnailUrl != null)
            CachedNetworkImage(
              imageUrl: thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => _ThumbnailFallback(),
            )
          else
            _ThumbnailFallback(),
          Container(
            color: Colors.black.withValues(alpha: 0.18),
          ),
          Center(
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.play_arrow_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Text(
                '${video.duration ?? 0}m',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: () {
          final videoUrl = video.url;
          final videoId = videoUrl == null || videoUrl.isEmpty
              ? null
              : YoutubeHelper.extractVideoId(videoUrl);

          if (videoId == null || videoId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('URL video không hợp lệ')),
            );
            return;
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => YoutubePage(
                videoUrl: videoId,
                title: video.title ?? 'Video',
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120.w,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: Colors.grey[300],
                ),
                child: _buildThumbnail(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title ?? 'Untitled Video',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    if (video.topic != null)
                      Text(
                        video.topic?.name ?? 'Unknown Topic',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thời lượng: ${video.duration ?? 0} phút',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Symbols.play_arrow_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThumbnailFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Icon(
        Symbols.video_library_rounded,
        size: 40.sp,
        color: Colors.grey[600],
      ),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return YoutubePage(
      videoUrl: videoUrl,
      title: title,
    );
  }
}
