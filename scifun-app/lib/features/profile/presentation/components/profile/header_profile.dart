import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class HeaderProfile extends StatelessWidget {
  static const String _avatarMascotLottiePath =
      'assets/lottie_json/cat_hide_and_seek.json';

  const HeaderProfile({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.remainingPackage,
    required this.isGuest,
    this.onGuestSyncTap,
  });
  final String imgUrl;
  final String name;
  final String remainingPackage;
  final bool isGuest;
  final VoidCallback? onGuestSyncTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 11.h,
      children: [
        SizedBox(
          width: 180.w,
          height: 180.w,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Transform.translate(
                offset: Offset(0, -75.h),
                child: IgnorePointer(
                  child: SizedBox(
                    width: 180.w,
                    height: 180.w,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Lottie.asset(
                        _avatarMascotLottiePath,
                        repeat: true,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: CustomNetworkAssetImage(
                        imagePath: imgUrl,
                        width: 100.w,
                        height: 100.w,
                      ),
                    ),
                    if (isGuest && onGuestSyncTap != null)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: _GuestSyncPulseButton(onTap: onGuestSyncTap!),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: AppColor.skyblue500,
              ),
        ),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.skyblue50,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                'Còn $remainingPackage',
                style: TextStyle(
                  color: AppColor.skyblue700,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (isGuest)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2CC),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Tài khoản khách',
                  style: TextStyle(
                    color: const Color(0xFF8A6700),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _GuestSyncPulseButton extends StatefulWidget {
  const _GuestSyncPulseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_GuestSyncPulseButton> createState() => _GuestSyncPulseButtonState();
}

class _GuestSyncPulseButtonState extends State<_GuestSyncPulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: const Color(0xFFEF7B6C),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.w),
          ),
          child: Icon(
            Symbols.sync_rounded,
            color: Colors.white,
            size: 16.w,
          ),
        ),
      ),
    );
  }
}
