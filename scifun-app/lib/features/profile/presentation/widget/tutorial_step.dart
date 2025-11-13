import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/domain/entities/instructions_entity.dart';

void showTutorialBottomSheet(
    BuildContext context, List<InstructionsEntity?> steps) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      final pageController = PageController();
      ValueNotifier<int> currentPage = ValueNotifier(0);

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Giữ chỗ trống thay cho icon bên trái
                SizedBox(
                  width: 60.w, // cùng kích thước với IconButton để cân đối
                ),

                // Tiêu đề ở giữa
                Text(
                  "Hướng dẫn mua gói",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Icon đóng bên phải
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: AppColor.hurricane800.withValues(alpha: 0.6),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Nội dung PageView
            SizedBox(
              height: 500.h,
              child: PageView.builder(
                controller: pageController,
                itemCount: steps.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      HtmlWidget(
                        step?.content ?? "",
                        textStyle: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      Center(
                        child: CustomNetworkAssetImage(
                          imagePath: step?.image ?? "",
                          height: 398.h,
                          width: 200.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Indicator
            ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, index, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    steps.length,
                    (i) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: index == i ? 12.w : 8.w,
                      height: index == i ? 12.w : 8.w,
                      decoration: BoxDecoration(
                        color: index == i
                            ? AppColor.primary600
                            : AppColor.backgroundTab,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 12.h),

            // Điều hướng 2 nút
            ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, index, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nút quay lại
                    if (index > 0)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(12.w),
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      )
                    else
                      const SizedBox(width: 60), // giữ khoảng cách cân bằng

                    // Nút tiến tới hoặc kết thúc
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(12.w),
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        if (index < steps.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        index < steps.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
