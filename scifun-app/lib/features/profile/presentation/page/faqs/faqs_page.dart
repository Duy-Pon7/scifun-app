import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/domain/entities/faqs_entity.dart';
import 'package:sci_fun/features/profile/presentation/widget/custom_expansion_tile.dart';

class FaqsPage extends StatelessWidget {
  final List<FaqsEntity> faqs; // <-- nhận từ Bloc

  const FaqsPage({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Câu hỏi thường gặp",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.primary600,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: faqs.map((faq) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: CustomExpansionTile(
                  title: faq.question ?? "",
                  titleFontSize: 17.sp,
                  backgroundColor: Colors.white,
                  borderColor: AppColor.border,
                  iconColor: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                  iconExpand: Icons.keyboard_arrow_down,
                  iconCollapse: Icons.keyboard_arrow_up,
                  child: Html(
                    data: faq.answer,
                    style: {
                      "body": Style(fontSize: FontSize(13.sp)),
                      "p": Style(margin: Margins.only(bottom: 8)),
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
