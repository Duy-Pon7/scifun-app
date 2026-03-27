import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/select_image_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/features/profile/presentation/components/profile_detail_page.dart/change_infomation_form.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

class ChangeInfomationPage extends StatelessWidget {
  const ChangeInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SelectImageCubit>(),
        ),
        BlocProvider(
          create: (context) {
            final token = sl<SharePrefsService>().getUserData();
            if (token != null) {
              return sl<UserCubit>()..getUser(token: token);
            }
            return sl<UserCubit>();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F8FC),
        appBar: BasicAppbar(
          title: "Thông tin cá nhân",
          showTitle: true,
          showBack: true,
        ),
        body: Stack(
          children: [
            Positioned(
              top: -90.h,
              right: -70.w,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE7F7FD),
                ),
              ),
            ),
            Positioned(
              top: 170.h,
              left: -80.w,
              child: Container(
                width: 170.w,
                height: 170.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0FBFF),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
              child: const ChangeInfomationForm(),
            ),
          ],
        ),
      ),
    );
  }
}
