import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/change_confirm_dialog.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/widget/subject_item.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';
import 'package:sci_fun/features/topic/presentation/pages/topic_page.dart';

class ListSubjects extends StatelessWidget {
  const ListSubjects({
    super.key,
    this.onSubjectSelected,
    this.selectedSubjectId = '',
  });

  final void Function(String subjectId, String subjectName)? onSubjectSelected;
  final String selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    final persistedSubjectId =
        (sl<SharePrefsService>().getSelectedSubjectId() ?? '').trim();
    final activeSelectedSubjectId = selectedSubjectId.trim().isNotEmpty
        ? selectedSubjectId.trim()
        : persistedSubjectId;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          width: double.infinity,
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'M\u00f4n h\u1ecdc',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
          builder: (context, state) {
            if (state is PaginationLoading<SubjectEntity>) {
              return SizedBox(
                height: 150.h,
                child: const Center(
                  child: AppLoadingIndicator(
                    message: '\u0110ang t\u1ea3i trang ch\u1ee7...',
                  ),
                ),
              );
            }

            if (state is PaginationSuccess<SubjectEntity>) {
              final items = state.items
                  .where((subject) => (subject.id ?? '').trim().isNotEmpty)
                  .take(3)
                  .toList(growable: false);

              if (items.isEmpty) {
                return SizedBox(
                  height: 150.h,
                  child: const Center(
                    child: AppEmptyState(
                      message: 'Không có môn học',
                      animationSize: 90,
                      spacing: 4,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 150.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var index = 0; index < items.length; index++) ...[
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final subject = items[index];
                            final subjectId = (subject.id ?? '').trim();
                            final subjectName =
                                subject.name?.trim().isNotEmpty == true
                                    ? subject.name!.trim()
                                    : 'M\u00f4n h\u1ecdc';
                            final isSelected =
                                activeSelectedSubjectId == subjectId;

                            return SubjectItem(
                              subjectName: subjectName,
                              imagePath: subject.image ?? '',
                              isSelected: isSelected,
                              cardWidth: double.infinity,
                              selectedBackgroundColor:
                                  AppColor.subject100(subjectName),
                              selectedBorderColor:
                                  AppColor.subject500(subjectName),
                              selectedTextColor:
                                  AppColor.subject700(subjectName),
                              onTap: () async {
                                if (subjectId.isEmpty) {
                                  return;
                                }

                                if (activeSelectedSubjectId.isNotEmpty &&
                                    activeSelectedSubjectId != subjectId) {
                                  final shouldChange =
                                      await showSubjectChangeConfirmDialog(
                                    context: context,
                                    nextSubjectName: subjectName,
                                  );
                                  if (shouldChange != true ||
                                      !context.mounted) {
                                    return;
                                  }
                                }

                                onSubjectSelected?.call(subjectId, subjectName);
                                if (!context.mounted) {
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopicPage(
                                      subjectId: subjectId,
                                      subjectName: subjectName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (index < items.length - 1) SizedBox(width: 8.w),
                    ],
                  ],
                ),
              );
            }

            if (state is PaginationError<SubjectEntity>) {
              return SizedBox(
                height: 150.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'L\u1ed7i khi t\u1ea3i m\u00f4n h\u1ecdc: ${state.error}',
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<SubjectCubit>()
                            .getSubjects(searchQuery: ''),
                        child: const Text('Th\u1eed l\u1ea1i'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 150.h,
              child: const Center(
                child: AppEmptyState(
                  message: 'Không có môn học',
                  animationSize: 90,
                  spacing: 4,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
