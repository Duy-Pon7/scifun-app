import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/cubit/lesson_cubit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  YoutubePlayerController? _controller;
  String? currentVideoId;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  void _initializePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null || videoId == currentVideoId) return;

    currentVideoId = videoId;
    _controller?.dispose(); // Dispose old controller if any

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        if (state is LessonDetailLoaded) {
          final videoUrl = state.lessonEntity.link ?? '';
          _initializePlayer(videoUrl);

          return _controller == null
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28.w),
                            topRight: Radius.circular(28.w),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            spacing: 32.h,
                            children: [
                              YoutubePlayer(
                                controller: _controller!,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: AppColor.primary600,
                                progressColors: const ProgressBarColors(
                                  playedColor: AppColor.primary600,
                                  handleColor: AppColor.primary300,
                                ),
                              ),
                              // Text(
                              //   state.lessonEntity.description ?? "",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .titleLarge!
                              //       .copyWith(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //   textAlign: TextAlign.center,
                              // ),
                              Html(
                                data: state.lessonEntity.description,
                                style: {
                                  "p": Style(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center,
                                    fontSize: FontSize(22.sp),
                                    maxLines: 3,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        }
        return SizedBox.shrink();
      },
    );
  }
}
