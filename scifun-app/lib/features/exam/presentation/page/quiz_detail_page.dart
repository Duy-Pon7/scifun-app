import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class QuizDetailPage extends StatefulWidget {
  const QuizDetailPage({super.key});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Chi tiết đề",
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                spacing: 24.h,
                children: [
                  _headerCard("Đề 1", "30 câu", "90 phút"),
                  _ruleCard("""
                    <ul>
                      <li>Đối với đề thi trắc nghiệm, chọn tất cả các đáp án đúng.</li>
                      <li>Sau khi kết thúc bài kiểm tra, bạn có thể xem điểm, đáp án và làm lại (nếu cần).</li>
                      <li>Đối với đề thi tự luận, sau khi nộp bài cần chờ thời gian chấm.</li>
                      <li>Bạn có thể vào lại bài thi sau để kiểm tra điểm.</li>
                      <li>Nếu thoát ra trong lúc làm bài, bài thi sẽ không lưu lại.</li>
                      <li>Đối với đề thi trắc nghiệm, chọn tất cả các đáp án đúng.</li>
                      <li>Sau khi kết thúc bài kiểm tra, bạn có thể xem điểm, đáp án và làm lại (nếu cần).</li>
                      <li>Đối với đề thi tự luận, sau khi nộp bài cần chờ thời gian chấm.</li>
                      <li>Bạn có thể vào lại bài thi sau để kiểm tra điểm.</li>
                      <li>Nếu thoát ra trong lúc làm bài, bài thi sẽ không lưu lại.</li>
                      <li>Đối với đề thi trắc nghiệm, chọn tất cả các đáp án đúng.</li>
                      <li>Sau khi kết thúc bài kiểm tra, bạn có thể xem điểm, đáp án và làm lại (nếu cần).</li>
                      <li>Đối với đề thi tự luận, sau khi nộp bài cần chờ thời gian chấm.</li>
                      <li>Bạn có thể vào lại bài thi sau để kiểm tra điểm.</li>
                      <li>Nếu thoát ra trong lúc làm bài, bài thi sẽ không lưu lại.</li>
                    </ul>
                  """),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: BasicButton(
                text: "Bắt đầu làm bài",
                onPressed: () {},
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard(String title, String totalQuestion, String duration) =>
      Container(
        padding: EdgeInsets.all(16.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 12,
              spreadRadius: -2,
              offset: Offset(
                0,
                6,
              ),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 7,
              spreadRadius: -3,
              offset: Offset(
                0,
                3,
              ),
            ),
          ],
        ),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Column(
              spacing: 12.h,
              children: [
                Row(
                  spacing: 6.w,
                  children: [
                    Icon(
                      Icons.help,
                      color: AppColor.primary500,
                      size: 60.w,
                    ),
                    Expanded(
                      child: Text(
                        totalQuestion,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColor.primary500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Row(
                  spacing: 6.w,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: AppColor.primary500,
                      size: 60.w,
                    ),
                    Expanded(
                      child: Text(
                        duration,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColor.primary500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );

  Widget _ruleCard(String content) => Container(
        padding: EdgeInsets.all(16.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 12,
              spreadRadius: -2,
              offset: Offset(
                0,
                6,
              ),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 7,
              spreadRadius: -3,
              offset: Offset(
                0,
                3,
              ),
            ),
          ],
        ),
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trước khi làm bài",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Html(
              data: content,
              style: {
                "ul": Style(
                  padding: HtmlPaddings.zero,
                  margin: Margins.zero,
                ),
                "li": Style(
                  padding: HtmlPaddings.zero,
                  margin: Margins.only(bottom: 8),
                  fontSize: FontSize(16.sp),
                  fontWeight: FontWeight.w400,
                )
              },
            ),
          ],
        ),
      );
}
