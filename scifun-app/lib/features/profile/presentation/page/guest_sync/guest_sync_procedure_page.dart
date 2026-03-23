import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/page/guest_sync/guest_sync_convert_page.dart';

class GuestSyncProcedurePage extends StatelessWidget {
  const GuestSyncProcedurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: 'Lộ trình đồng bộ guest',
        showTitle: true,
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: AppColor.skyblue50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sync_rounded,
                    color: AppColor.skyblue500,
                    size: 38.w,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Thủ tục đồng bộ dữ liệu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Nhập thông tin tài khoản, nhấn đồng bộ để hệ thống gửi OTP, xác thực OTP thành công sẽ thoát ứng dụng.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              SizedBox(height: 20.h),
              const _StepCard(
                index: 1,
                title: 'Nhập thông tin đồng bộ',
                description: 'Nhập email, mật khẩu, họ tên rồi nhấn đồng bộ.',
              ),
              SizedBox(height: 10.h),
              const _StepCard(
                index: 2,
                title: 'Xác thực OTP',
                description: 'Nhập mã OTP gửi về email để kích hoạt tài khoản.',
              ),
              const Spacer(),
              BasicButton(
                text: 'Bắt đầu',
                onPressed: () {
                  Navigator.push(
                    context,
                    slidePage(const GuestSyncConvertPage()),
                  );
                },
                width: double.infinity,
                fontSize: 17.sp,
                backgroundColor: AppColor.skyblue400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.skyblue100,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColor.skyblue600,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
