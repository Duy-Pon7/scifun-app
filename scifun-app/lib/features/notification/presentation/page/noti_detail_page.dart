import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/notification/presentation/cubit/noti_cubit.dart';

class NotiDetailPage extends StatelessWidget {
  const NotiDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Chi tiết thông báo",
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
        body: BlocBuilder<NotiCubit, NotiState>(
          builder: (context, state) {
            if (state is NotiLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NotiDetailLoaded) {
              final noti = state.newsDetail;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 20.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.primary100),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Image.asset(AppImage.noti2),
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Text(
                        noti.title ?? "Không có tiêu đề",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 17.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColor.hurricane800,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            noti.createdAt != null
                                ? "${noti.createdAt?.day.toString().padLeft(2, '0')}/${noti.createdAt?.month.toString().padLeft(2, '0')}/${noti.createdAt?.year}"
                                : "",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 13.sp,
                                  color: AppColor.hurricane800,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        noti.message ?? "Không có nội dung",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is NotiError) {
              return Center(child: Text('❌ ${state.message}'));
            } else {
              return Center(child: Text("Không có dữ liệu"));
            }
          },
        ));
  }
}
