import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/helper/level_helper.dart';
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
            final userLevel =
                state is UserLoaded ? state.user.data?.level : null;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textName(name: userName, level: userLevel),
                _avatarWithMascot(avatarUrl: avatarUrl),
              ],
            );
          },
        ),
        _inputSearch(),
      ],
    );
  }

  Widget _textName({required String? name, required String? level}) {
    final subjectDisplayName = _subjectDisplayName(widget.subjectName);
    final normalizedLevel = LevelHelper.normalize(level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subjectDisplayName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 17.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            if (normalizedLevel != null) ...[
              SizedBox(width: 8.w),
              _buildLevelBadge(normalizedLevel),
            ],
          ],
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

  Color _levelColor(String level) {
    final normalized = LevelHelper.normalize(level);
    if (normalized == LevelHelper.advanced) return Colors.red.shade100;
    if (normalized == LevelHelper.intermediate) return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  Widget _buildLevelBadge(String level) {
    final backgroundColor = _levelColor(level);
    final displayLevel = LevelHelper.toVietnamese(level);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Text(
        displayLevel,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColor.hurricane900,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
            ),
      ),
    );
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
                  Symbols.person,
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
                Symbols.search_rounded,
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
