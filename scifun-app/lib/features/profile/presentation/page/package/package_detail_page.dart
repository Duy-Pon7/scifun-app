import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';
import 'package:sci_fun/features/profile/presentation/widget/package_item.dart';

class PackageDetailPage extends StatelessWidget {
  final PackagesEntity package;
  const PackageDetailPage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
          color: AppColor.primary600,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Chi tiết gói",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: PackageItem(
            id: package.id ?? 0,
            title: package.name ?? "",
            description: package.description.join('\n'),
            price: package.price ?? "",
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
