import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/page/search_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

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
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              print("UserState in HeaderHome: ${state.user.data?.avatar}");
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _textName(name: state.user.data?.fullname),
                  _avatar(avatarUrl: state.user.data?.avatar),
                ],
              );
            } else if (state is UserError) {
              return Text(
                'Lỗi tải thông tin người dùng',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        _inputSearch(),
      ],
    );
  }

  Widget _textName({required String? name}) => Column(
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
          Text(
            name ?? '',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      );

  Widget _avatar({required String? avatarUrl}) => Container(
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
            imagePath: avatarUrl ?? '',
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
            hintText: "Tìm kiếm chủ đề",
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
