import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/helper/transition_page.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/profile/domain/entities/packages_entity.dart';
import 'package:thilop10_3004/features/profile/presentation/bloc/package_bloc.dart';
import 'package:thilop10_3004/features/profile/presentation/page/package/package_detail_page.dart';
import 'package:thilop10_3004/features/profile/presentation/widget/package_item.dart';

class PackagePage extends StatefulWidget {
  final String? fullname;
  final String? remainingPackage;
  final bool? flagpop;
  const PackagePage(
      {required this.fullname,
      required this.remainingPackage,
      this.flagpop,
      super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<PackageBloc>()..add(PackageGetSession()),
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          automaticallyImplyLeading: widget.flagpop != false,
          leading: (widget.flagpop == false)
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                  ),
                  color: AppColor.primary600,
                  onPressed: () => Navigator.of(context).pop(),
                ),
          title: Text(
            "Gói thành viên",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  _infoCard(),
                  _carouselPackages(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard() => Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x1AFF0300),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 11.h,
        children: [
          Text(
            widget.fullname ?? "Khách",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColor.primary500,
                ),
          ),
          RichText(
            text: TextSpan(
              text: "Gói còn lại: ",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColor.hurricane800.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
              children: [
                TextSpan(
                  text: widget.remainingPackage,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ));
}

Widget _carouselPackages() {
  final screenHeight = ScreenUtil().screenHeight;

  return BlocBuilder<PackageBloc, PackageState>(
    builder: (context, state) {
      if (state is PackageLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is PackageFailure) {
        return Center(child: Text("Lỗi: ${state.message}"));
      } else if (state is PackageSuccess) {
        final packages = state.package;

        return CarouselSlider(
          items: packages
              .whereType<PackagesEntity>() // bỏ phần tử null nếu có
              .map(
                (pkg) => PackageItem(
                  id: pkg.id ?? 0,
                  title: pkg.name ?? "Không có tên",
                  description: pkg.description.join('\n'),
                  price: pkg.price ?? "0",
                  maxLines: ScreenUtil().screenWidth > 400 ? 20 : 15,
                  onTap: () => Navigator.push(
                    context,
                    slidePage(PackageDetailPage(package: pkg)),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: screenHeight * 0.74,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
        );
      }

      return SizedBox(); // Trạng thái initial
    },
  );
}
