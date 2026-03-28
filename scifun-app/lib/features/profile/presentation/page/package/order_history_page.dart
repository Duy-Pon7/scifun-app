import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/profile/presentation/cubit/order_history_cubit.dart';
import 'package:sci_fun/features/profile/presentation/widget/order_history_item.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderHistoryCubit>()..fetchInitial(),
      child: Scaffold(
        appBar: const BasicAppbar(title: 'Lịch sử mua gói'),
        body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(
                child: AppLoadingIndicator(
                  message: 'Đang tải lịch sử mua gói...',
                ),
              );
            }

            if (state is OrderHistoryError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<OrderHistoryCubit>().fetchInitial(),
              );
            }

            if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: AppEmptyState(message: 'Bạn chưa có giao dịch nào'),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<OrderHistoryCubit>().fetchInitial(),
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.orders.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    if (index < state.orders.length) {
                      return OrderHistoryItem(order: state.orders[index]);
                    }

                    return _LoadMoreTile(
                      isLoading: state.isLoadingMore,
                      onTap: () =>
                          context.read<OrderHistoryCubit>().fetchMore(),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreTile extends StatelessWidget {
  const _LoadMoreTile({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      child: Center(
        child: TextButton(
          onPressed: onTap,
          child: const Text('Xem thêm'),
        ),
      ),
    );
  }
}
