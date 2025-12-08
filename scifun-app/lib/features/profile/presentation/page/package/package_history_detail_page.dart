// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/cubit/select_image_cubit.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/enums/enum_package.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/profile/domain/entities/package_history_entity.dart';
// import 'package:sci_fun/features/profile/presentation/components/package/network_image_section.dart';
// import 'package:sci_fun/features/profile/presentation/widget/package_alert_item.dart';
// import 'package:sci_fun/features/profile/presentation/widget/package_detail_history_item.dart';

// class PackageHistoryDetailPage extends StatelessWidget {
//   final NotificationEntity? item;
//   const PackageHistoryDetailPage({super.key, this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppbar(
//         title: "Chi tiết lịch sử gói cước",
//         showTitle: true,
//         showBack: true,
//       ),
//       body: BlocProvider(
//         create: (context) => sl<SelectImageCubit>(),
//         child: BlocBuilder<SelectImageCubit, SelectImageState>(
//           builder: (context, imageState) {
//             return SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//                 child: Column(
//                   children: [
//                     PackageDetailHistoryItem(
//                       item: item,
//                       title: item?.package?.name ?? "Gói không rõ",
//                       price: item?.package?.price.toString() ?? "Không rõ",
//                       date: item?.createdAt ?? DateTime.now(),
//                       status: PackageStatusX.fromString(item?.approvalStatus),
//                     ),
//                     SizedBox(height: 24.h),
//                     item?.cancellationReason != null
//                         ? PackageAlertItem(
//                             title: "Lý do huỷ",
//                             content: item?.cancellationReason ?? "Không rõ",
//                           )
//                         : SizedBox(),
//                     SizedBox(height: 24.h),
//                     NetworkImageSection(
//                       imageUrl: item?.paymentConfirmationImage,
//                     ),
//                   ],
//                 ));
//           },
//         ),
//       ),
//     );
//   }
// }
