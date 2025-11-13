import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/pagination_cubit.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/enums/enum_package.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/profile/domain/entities/package_history_entity.dart';
import 'package:thilop10_3004/features/profile/domain/usecase/get_history_packages.dart';
import 'package:thilop10_3004/features/profile/presentation/cubit/package_history_cubit.dart';
import 'package:thilop10_3004/features/profile/presentation/page/package/package_history_detail_page.dart';
import 'package:thilop10_3004/features/profile/presentation/widget/package_history_item.dart';

class PackageHistoryPage extends StatefulWidget {
  const PackageHistoryPage({super.key});

  @override
  State<PackageHistoryPage> createState() => _PackageHistoryPageState();
}

class _PackageHistoryPageState extends State<PackageHistoryPage> {
  late final ScrollController _scrollController;
  late final cubit = context.read<PackageHistoryCubit>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Lấy dữ liệu trang đầu
    cubit.paginateData(param: PackageHistoryParams(page: 1));
  }

  void _onScroll() {
    final cubit = context.read<PackageHistoryCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !cubit.isLastPage) {
      cubit.paginateData(
        param: PackageHistoryParams(
            page: cubit.items.length ~/ 10 + 1), // Tính page hiện tại
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Lịch sử mua gói',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: BlocBuilder<PackageHistoryCubit,
            PaginationState<NotificationEntity?>>(
          builder: (context, state) {
            final cubit = context.read<PackageHistoryCubit>();

            if (state is PaginationLoading && cubit.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PaginationFailed && cubit.items.isEmpty) {
              return Center(child: Text("Lỗi:"));
            }

            if (cubit.items.isEmpty) {
              return const Center(child: Text("Chưa có lịch sử mua gói"));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await cubit.refreshData(param: PackageHistoryParams(page: 1));
              },
              child: ListView.separated(
                controller: _scrollController,
                itemCount: cubit.items.length + 1,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index < cubit.items.length) {
                    final item = cubit.items[index];
                    return PackageHistoryItem(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PackageHistoryDetailPage(item: item),
                          ),
                        );
                      },
                      title: item!.package?.name.toString() ?? "Không rõ",
                      price: item.package?.price.toString() ?? "Không rõ",
                      date: item.createdAt ?? DateTime.now(),
                      status: PackageStatusX.fromString(item.approvalStatus),
                    );
                  } else {
                    return cubit.isLastPage
                        ? const SizedBox.shrink()
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
