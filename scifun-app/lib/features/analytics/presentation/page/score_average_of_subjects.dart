import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/paginator_cubit.dart';

import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/analytics/presentation/widget/custom_expansion_tile_subjects.dart';
import 'package:thilop10_3004/features/analytics/presentation/widget/subject_item.dart';
import 'package:thilop10_3004/features/exam/data/model/examset_model.dart';
import 'package:thilop10_3004/features/exam/domain/usecase/get_examset.dart';

class ScoreAverageOfSubjects extends StatefulWidget {
  const ScoreAverageOfSubjects({super.key});

  @override
  State<ScoreAverageOfSubjects> createState() => _ScoreAverageOfSubjectsState();
}

class _ScoreAverageOfSubjectsState extends State<ScoreAverageOfSubjects> {
  late final PaginatorCubit<ExamsetModel, dynamic> _paginator;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _paginator = PaginatorCubit<ExamsetModel, dynamic>(
      usecase: sl<GetExamset>(), // Dùng usecase giống như trang ExamsetPage
    )..paginateData();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _paginator.paginateData();
        }
      });
  }

  @override
  void dispose() {
    _paginator.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Điểm số thi thử",
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
        value: _paginator,
        child: BlocBuilder<PaginatorCubit<ExamsetModel, dynamic>,
            PaginatorState<ExamsetModel>>(
          builder: (context, state) {
            if (state is PaginatorLoading<ExamsetModel>) {
              return const Center(child: CircularProgressIndicator());
            }

            final items =
                context.read<PaginatorCubit<ExamsetModel, dynamic>>().items;

            if (state is PaginatorFailed<ExamsetModel> || items.isEmpty) {
              return Center(child: Text('Không có dữ liệu bài thi'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<PaginatorCubit<ExamsetModel, dynamic>>()
                    .refreshData();
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.all(16.w),
                itemCount: items.length +
                    (state is PaginatorLoadMore<ExamsetModel> ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    // Hiện loader khi load thêm trang
                    return const Center(child: CircularProgressIndicator());
                  }

                  final examset = items[index];
                  final total = examset.quizzes.fold<int>(
                    0,
                    (previousValue, subject) =>
                        previousValue + (subject.quizResult?.score ?? 0),
                  );
                  return CustomExpansionTileSubjects(
                    total: total,
                    completedCount: 0,
                    title: examset.title,
                    backgroundColor: Colors.white,
                    borderColor: AppColor.primary300,
                    iconColor: AppColor.primary600,
                    titleFontSize: 18.sp,
                    children: examset.quizzes.map((subject) {
                      return SubjectItem(
                        title: subject.name ?? '',
                        completedTime:
                            subject.quizResult?.updatedAt ?? DateTime.now(),
                        score: subject.quizResult?.score?.toString() ?? '',
                      );
                    }).toList(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
