import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/select_image_cubit.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/enums/enum_package.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/profile/domain/entities/package_history_entity.dart';
import 'package:thilop10_3004/features/profile/presentation/components/package/network_image_section.dart';
import 'package:thilop10_3004/features/profile/presentation/widget/package_alert_item.dart';
import 'package:thilop10_3004/features/profile/presentation/widget/package_detail_history_item.dart';

class PackageHistoryDetailPage extends StatelessWidget {
  final NotificationEntity? item;
  const PackageHistoryDetailPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Chi tiết lịch sử',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColor.primary600,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => sl<SelectImageCubit>(),
        child: BlocBuilder<SelectImageCubit, SelectImageState>(
          builder: (context, imageState) {
            return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  children: [
                    PackageDetailHistoryItem(
                      item: item,
                      title: item?.package?.name ?? "Gói không rõ",
                      price: item?.package?.price.toString() ?? "Không rõ",
                      date: item?.createdAt ?? DateTime.now(),
                      status: PackageStatusX.fromString(item?.approvalStatus),
                    ),
                    SizedBox(height: 24.h),
                    item?.cancellationReason != null
                        ? PackageAlertItem(
                            title: "Lý do huỷ",
                            content: item?.cancellationReason ?? "Không rõ",
                          )
                        : SizedBox(),
                    SizedBox(height: 24.h),
                    NetworkImageSection(
                      imageUrl: item?.paymentConfirmationImage,
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
