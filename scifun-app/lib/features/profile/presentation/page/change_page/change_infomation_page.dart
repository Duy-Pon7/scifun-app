import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/select_image_cubit.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/profile/presentation/components/profile_detail_page.dart/change_infomation_form.dart';

class ChangeInfomationPage extends StatelessWidget {
  const ChangeInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Thông tin cá nhân",
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
        body: MultiBlocProvider(
          providers: [
            BlocProvider<SelectImageCubit>(
              create: (_) => SelectImageCubit(),
            ),
          ],
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ChangeInfomationForm(),
          ),
        ),
      ),
    );
  }
}
