import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/page/search_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({
    super.key,
    this.subjectName,
  });

  final String? subjectName;

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  static const String _avatarMascotLottiePath =
      'assets/lottie_json/cat_hide_and_seek.json';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = sl<SharePrefsService>().getUserData();
      if (token != null && token.isNotEmpty) {
        context.read<UserCubit>().getUser(token: token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.h,
      children: [
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserError) {
              return Text(
                'Lỗi tải thông tin người dùng',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
              );
            }

            final userName =
                state is UserLoaded ? state.user.data?.fullname : null;
            final avatarUrl =
                state is UserLoaded ? state.user.data?.avatar : null;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textName(name: userName),
                _avatarWithMascot(avatarUrl: avatarUrl),
              ],
            );
          },
        ),
        _inputSearch(),
      ],
    );
  }

  Widget _textName({required String? name}) {
    final subjectDisplayName = _subjectDisplayName(widget.subjectName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subjectDisplayName,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
        ),
        Text(
          name?.trim().isNotEmpty == true ? name!.trim() : ' ',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  String _subjectDisplayName(String? subjectName) {
    final normalized = subjectName?.trim();
    if (normalized == null || normalized.isEmpty) {
      return 'Vật lý';
    }
    return normalized;
  }

  Widget _avatarWithMascot({required String? avatarUrl}) => SizedBox(
        width: 58.w,
        height: 58.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 60.h,
              left: 10.w,
              right: 0,
              child: IgnorePointer(
                child: SizedBox(
                  width: 74.w,
                  height: 74.w,
                  child: Lottie.asset(
                    _avatarMascotLottiePath,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _avatar(avatarUrl: avatarUrl),
            ),
          ],
        ),
      );

  Widget _avatar({required String? avatarUrl}) => Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 26.sp,
                )
              : CustomNetworkAssetImage(
                  imagePath: avatarUrl,
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
            hintText: 'Tìm kiếm chủ đề',
            hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  color: AppColor.hurricane800.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
            enabledBorder: Theme.of(context)
                .inputDecorationTheme
                .enabledBorder!
                .copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
            errorBorder: Theme.of(context)
                .inputDecorationTheme
                .errorBorder!
                .copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: Theme.of(context)
                .inputDecorationTheme
                .focusedBorder!
                .copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
            disabledBorder: Theme.of(context)
                .inputDecorationTheme
                .disabledBorder!
                .copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
          ),
        ),
      );
}
