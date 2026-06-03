import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/app_youtube_player.dart';
import 'package:sci_fun/features/home/presentation/cubit/lesson_cubit.dart';

class VideoContent extends StatelessWidget {
  const VideoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        if (state is! LessonDetailLoaded) {
          return const SizedBox.shrink();
        }

        final videoUrl = state.lessonEntity.link ?? '';

        return Column(
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
                      AppYoutubePlayer(videoUrl: videoUrl),
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
      },
    );
  }
}
