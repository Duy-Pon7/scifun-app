import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_category_entity.dart';

class TopicPage<T, P> extends StatefulWidget {
  const TopicPage({
    super.key,
    required this.title,
    required this.param,
    required this.usecase,
    required this.itemBuilder,
  });
  final String title;
  final P param;
  final Usecase<List<T>, PaginationParam<P>> usecase;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  State<TopicPage<T, P>> createState() => _TopicPageState<T, P>();
}

class _TopicPageState<T, P> extends State<TopicPage<T, P>> {
  late final PaginationCubit<T, P> _paginationCubit;
  late final ScrollController _scrollCon;

  @override
  void initState() {
    super.initState();

    _paginationCubit = PaginationCubit<T, P>(
      usecase: widget.usecase,
    )..paginateData(param: widget.param);

    // Listen scroll action
    _scrollCon = ScrollController()
      ..addListener(() {
        if (_scrollCon.position.pixels == _scrollCon.position.maxScrollExtent) {
          _paginationCubit.paginateData(
            param: widget.param,
          );
        } else if (_paginationCubit is PaginationLoaded<LessonCategoryEntity> &&
            !_paginationCubit.isLastPage) {
          _paginationCubit.paginateData(
            param: widget.param,
          );
        }
      });
  }

  @override
  void dispose() {
    _paginationCubit.close();
    _scrollCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: "Chi tiết lịch sử gói cước",
        showTitle: true,
        showBack: true,
      ),
      body: BlocProvider.value(
        value: _paginationCubit,
        child: BlocBuilder<PaginationCubit<T, P>, PaginationState<T>>(
          builder: (context, state) {
            if (state is PaginationLoading<T>) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PaginationLoaded<T> ||
                state is PaginationLoadMore<T>) {
              // Notification list
              final items = _paginationCubit.items;
              if (items.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onLoadMoreWhenTheContentUnOccupiesTheWholePage();
                });
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator.adaptive(
                      color: AppColor.primary600,
                      onRefresh: () async =>
                          _paginationCubit.refreshData(param: widget.param),
                      child: Visibility(
                        visible: items.isNotEmpty,
                        child: ListView.separated(
                          controller: _scrollCon,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 24.h,
                          ),
                          physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemBuilder: (context, index) =>
                              widget.itemBuilder(context, items[index]),
                          itemCount: items.length,
                          shrinkWrap: true,
                          separatorBuilder: (_, i) => SizedBox(height: 16.h),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: state is PaginationLoadMore<T>,
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            } else if (state is PaginationFailed<T>) {
              return Center(child: Text("Đã xảy ra lỗi: ${state.message}"));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

// When the content unoccupies the whole page
  void _onLoadMoreWhenTheContentUnOccupiesTheWholePage() {
    if (_scrollCon.position.maxScrollExtent > 0) {
      return;
    }

    final currentState = _paginationCubit.state;
    if (_scrollCon.position.pixels == 0 &&
        currentState is PaginationLoaded<T> &&
        !_paginationCubit.isLastPage) {
      _paginationCubit.paginateData(param: widget.param);
    }
  }
}
