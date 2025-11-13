import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/helper/open_link.dart';
import 'package:thilop10_3004/features/home/presentation/cubit/lesson_cubit.dart';

class TheoryContent extends StatelessWidget {
  const TheoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        if (state is LessonDetailLoaded) {
          EasyLoading.dismiss();
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Html(
                  data: state.lessonEntity.description,
                  style: {
                    "p": Style(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      fontSize: FontSize(22.sp),
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
              ),
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
                    child: Html(
                      data: state.lessonEntity.content,
                      onLinkTap: (url, _, __) async {
                        await openLink(link: url!);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is LessonLoading) {
          EasyLoading.show(
            status: 'Đang tải',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is LessonError) {
          EasyLoading.dismiss();
          EasyLoading.showToast(
            state.message,
            toastPosition: EasyLoadingToastPosition.bottom,
          );
        } else {
          EasyLoading.dismiss();
        }
        return SizedBox();
      },
    );
  }
}
