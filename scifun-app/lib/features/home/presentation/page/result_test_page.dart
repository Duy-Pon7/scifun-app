import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sci_fun/common/helper/get_category_score.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/assets/app_vector.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/homework_result_page.dart';

class ResultTestPage extends StatelessWidget {
  const ResultTestPage(
      {super.key, this.submissionData, this.timeTaken, this.quizzId});

  final Map<String, dynamic>? submissionData;
  final String? timeTaken;
  final int? quizzId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<QuizzCubit>()..addQuizz(quizzParam: submissionData ?? {}),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Kết quả bài làm",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColor.primary600,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<QuizzCubit, QuizzState>(
          builder: (context, state) {
            if (state is QuizzDetailLoaded) {
              return Column(
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.primary100,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(250, 100),
                                bottomRight: Radius.elliptical(250, 100)),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.primary200,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(200, 200),
                                bottomRight: Radius.elliptical(200, 200)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 170.w,
                            height: 170.w,
                            decoration: BoxDecoration(
                                color: AppColor.primary600,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.r))),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset(
                            AppVector.trophy,
                            width: 180.w,
                            height: 210.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 32.h,
                        horizontal: 16.w,
                      ),
                      child: Column(
                        spacing: 32.h,
                        children: [
                          Column(
                            spacing: 12.h,
                            children: [
                              Text(
                                getCategoryScore(
                                    state.quizzEntity.quizResult!.score ?? 0),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 34.sp,
                                      color: AppColor.primary500,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                "Hoàn thành kiểm tra",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 24.h),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 0.3,
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  spacing: 8.h,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.quizzEntity.quizResult!
                                          .correctAnswers
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      "Số câu đúng",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: VerticalDivider(
                                    thickness: 0.3,
                                    color: Colors.black.withValues(alpha: 0.3),
                                    width: 0.3,
                                  ),
                                ),
                                Column(
                                  spacing: 8.h,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.quizzEntity.quizResult!.score
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      "Điểm",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: VerticalDivider(
                                    thickness: 0.3,
                                    color: Colors.black.withValues(alpha: 0.3),
                                    width: 0.3,
                                  ),
                                ),
                                Column(
                                  spacing: 8.h,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      timeTaken ?? "00’00”",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      "Thời gian",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                              color: Colors.black.withValues(alpha: 0.3),
                              width: 0.3),
                        ),
                      ),
                      child: Row(
                        spacing: 12.w,
                        children: [
                          Expanded(
                            child: BasicButton(
                              text: "Xem đáp án",
                              fontSize: 20.sp,
                              onPressed: () {
                                final quizzCubit = context.read<QuizzCubit>();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: quizzCubit,
                                      child:
                                          HomeworkResultPage(quizzId: quizzId),
                                    ),
                                  ),
                                );
                              },
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              backgroundColor: Colors.transparent,
                              border: true,
                              borderWidth: 1,
                              textColor: AppColor.primary500,
                              borderColor: AppColor.primary600,
                            ),
                          ),
                          Expanded(
                            child: BasicButton(
                              text: "Bài học tiếp theo",
                              fontSize: 20.sp,
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              backgroundColor: AppColor.primary600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
