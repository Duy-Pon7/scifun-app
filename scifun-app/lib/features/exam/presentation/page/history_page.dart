import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/paginator_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/exam/presentation/widget/history_item.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_result_entity.dart';
import 'package:sci_fun/features/home/domain/usecase/get_quizz_result.dart';
import 'package:sci_fun/features/home/presentation/cubit/quizz_result_paginator_cubit.dart';
import 'package:sci_fun/features/notification/presentation/page/noti_page.dart';

class HistoryPage extends StatefulWidget {
  final int quizzId;
  const HistoryPage({super.key, required this.quizzId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final ScrollController _scrollController;
  late final PaginatorCubit<QuizzResultEntity, dynamic> _historyCubit;
  @override
  void initState() {
    _historyCubit = QuizzResultPaginatorCubit(
      usecase: sl<GetQuizzResult>(),
      quizzId: widget.quizzId,
    )..fetchFirstPage(); // gọi page đầu tiên

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _historyCubit.paginateData(
            param: PaginationParamId<void>(
              page: 0, // có thể đổi page nếu cần
              id: widget.quizzId,
            ),
          );
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _historyCubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Lịch sử làm bài",
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
      body: BlocProvider.value(
        value: _historyCubit,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<QuizzResultPaginatorCubit,
              PaginatorState<QuizzResultEntity>>(
            builder: (context, state) {
              print("state history $state");
              final items = _historyCubit.items;

              if (state is PaginatorLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PaginatorFailed) {
                return CustomizeTryAgain(
                  error: "Không tải được lịch sử",
                  onPressed: () => _historyCubit.refreshData(),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _historyCubit.refreshData(),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      if (state is PaginatorLoadMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    final item = items[index];
                    return HistoryItem(item);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
