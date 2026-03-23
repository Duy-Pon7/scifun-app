import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class GuestSyncProcedurePage extends StatelessWidget {
  const GuestSyncProcedurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dong bo du lieu guest'),
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
                'Trang nay la placeholder cho luong dong bo du lieu tu tai khoan guest sang tai khoan chinh. API se duoc ket noi sau.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              SizedBox(height: 20.h),
              _StepCard(
                index: 1,
                title: 'Xac nhan tai khoan',
                description:
                    'Kiem tra thong tin tai khoan guest va han su dung hien tai.',
              ),
              SizedBox(height: 10.h),
              _StepCard(
                index: 2,
                title: 'Chuan bi du lieu',
                description: 'Tap hop cac thong tin hoc tap can duoc dong bo.',
              ),
              SizedBox(height: 10.h),
              _StepCard(
                index: 3,
                title: 'Dong bo',
                description:
                    'Gui yeu cau dong bo len server ngay khi API san sang.',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.sync),
                  label: const Text('Bat dau dong bo (sap cap nhat)'),
                ),
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
