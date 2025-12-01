import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/select_image_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/components/profile_detail_page.dart/change_infomation_form.dart';

class ChangeInfomationPage extends StatelessWidget {
  const ChangeInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Thông tin cá nhân",
          showTitle: true,
          showBack: true,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<SelectImageCubit>(
              create: (_) => SelectImageCubit(),
            ),
          ],
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(), // ChangeInfomationForm(),
          ),
        ),
      ),
    );
  }
}
