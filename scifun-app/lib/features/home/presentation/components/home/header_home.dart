import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/widget/basic_input_field.dart';
import 'package:thilop10_3004/common/widget/custom_network_asset_image.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thilop10_3004/features/home/presentation/page/search_page.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({super.key});

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.h,
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _textName(),
              _avatar(),
            ],
          ),
        ),
        _inputSearch(),
      ],
    );
  }

  Widget _textName() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào,',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
          ),
          if (context.read<AuthBloc>().state is AuthUserSuccess)
            Text(
              (context.read<AuthBloc>().state as AuthUserSuccess)
                      .user!
                      .fullname ??
                  "",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
        ],
      );

  Widget _avatar() => Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.r),
          child: CustomNetworkAssetImage(
            imagePath: context.read<AuthBloc>().state is AuthUserSuccess
                ? (context.read<AuthBloc>().state as AuthUserSuccess)
                        .user!
                        .avatar ??
                    ""
                : "",
            width: 50.w,
            height: 50.w,
          ),
        ),
      );

  Widget _inputSearch() => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: BasicInputField(
            enabled: false,
            controller: TextEditingController(),
            fillColor: AppColor.hurricane500.withValues(alpha: 0.12),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 7.w),
              child: Icon(
                Icons.search_rounded,
                color: AppColor.hurricane800.withValues(alpha: 0.6),
              ),
            ),
            hintText: "Tìm kiếm bài học",
            hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  color: AppColor.hurricane800.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
            enabledBorder: Theme.of(context)
                .inputDecorationTheme
                .enabledBorder!
                .copyWith(borderSide: BorderSide(color: Colors.transparent)),
            errorBorder: Theme.of(context)
                .inputDecorationTheme
                .errorBorder!
                .copyWith(borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: Theme.of(context)
                .inputDecorationTheme
                .focusedBorder!
                .copyWith(borderSide: BorderSide(color: Colors.transparent)),
            disabledBorder: Theme.of(context)
                .inputDecorationTheme
                .disabledBorder!
                .copyWith(borderSide: BorderSide(color: Colors.transparent)),
          ),
        ),
      );
}
