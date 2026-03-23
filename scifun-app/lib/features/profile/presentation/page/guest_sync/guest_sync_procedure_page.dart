import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/page/signup/signup_page.dart';

class GuestSyncProcedurePage extends StatelessWidget {
  const GuestSyncProcedurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lo trinh dong bo guest'),
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
                'Thu tuc dong bo du lieu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Ban se tao tai khoan moi, xac thuc OTP, sau do nhap lai thong tin de dong bo du lieu guest.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              SizedBox(height: 20.h),
              const _StepCard(
                index: 1,
                title: 'Dang ky tai khoan',
                description:
                    'Nhap email, mat khau, ho ten va tao tai khoan moi.',
              ),
              SizedBox(height: 10.h),
              const _StepCard(
                index: 2,
                title: 'Xac thuc OTP',
                description: 'Nhap ma OTP gui ve email de kich hoat tai khoan.',
              ),
              SizedBox(height: 10.h),
              const _StepCard(
                index: 3,
                title: 'Dong bo du lieu',
                description:
                    'Nhap lai thong tin va nhan dong bo, he thong se dang xuat de dang nhap lai.',
              ),
              const Spacer(),
              BasicButton(
                text: 'Bat dau',
                onPressed: () {
                  Navigator.push(
                    context,
                    slidePage(const SignupPage(isGuestConvertFlow: true)),
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
