import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class ChangeSubjectPage extends StatefulWidget {
  const ChangeSubjectPage({super.key});

  @override
  State<ChangeSubjectPage> createState() => _ChangeSubjectPageState();
}

class _ChangeSubjectPageState extends State<ChangeSubjectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subjectCubit = context.read<SubjectCubit>();
      final state = subjectCubit.state;
      if (state is! PaginationSuccess<SubjectEntity> &&
          state is! PaginationLoading<SubjectEntity> &&
          state is! PaginationLoadingMore<SubjectEntity>) {
        subjectCubit.loadInitial(searchQuery: '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: 'Đổi môn học',
      ),
      body: BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
        builder: (context, state) {
          if (state is PaginationLoading<SubjectEntity> &&
              state.items.isEmpty) {
            return const Center(
              child: AppLoadingIndicator(message: 'Đang tải danh sách môn...'),
            );
          }

          if (state is PaginationError<SubjectEntity> && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không tải được danh sách môn học'),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {
                      context.read<SubjectCubit>().loadInitial(searchQuery: '');
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final subjects = state.items
              .where((subject) => (subject.id ?? '').isNotEmpty)
              .toList(growable: false);
          final selectedSubjectId =
              (sl<SharePrefsService>().getSelectedSubjectId() ?? '').trim();

          if (subjects.isEmpty) {
            return const Center(
              child: AppEmptyState(message: 'Không có môn học'),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            itemCount: subjects.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (_, index) {
              final subject = subjects[index];
              final subjectId = (subject.id ?? '').trim();
              final subjectName = subject.name?.trim().isNotEmpty == true
                  ? subject.name!.trim()
                  : 'Môn học';
              final subjectDescription = (subject.description ?? '').trim();
              final accentColor = AppColor.subject500(subjectName);
              final pressedAccentColor = AppColor.subject600(subjectName);
              final softAccentColor = AppColor.subject100(subjectName);
              final isCurrentSubject = selectedSubjectId == subjectId;

              return BasicButton(
                onPressed: () async {
                  if (subjectId.isEmpty) {
                    return;
                  }

                  await sl<SharePrefsService>().saveSelectedSubject(
                    subjectId: subjectId,
                    subjectName: subjectName,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pop(context);
                },
                width: double.infinity,
                height: 112.h,
                borderRadius: BorderRadius.circular(14.r),
                backgroundColor: accentColor,
                buttonColor: pressedAccentColor,
                textColor: Colors.white,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  children: [
                    _SubjectLeadingImage(
                      subject: subject,
                      softAccentColor: softAccentColor,
                      accentColor: pressedAccentColor,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subjectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (subjectDescription.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              subjectDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white.withValues(alpha: 0.92),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      isCurrentSubject
                          ? Symbols.check_circle_rounded
                          : Symbols.arrow_forward_ios_rounded,
                      size: isCurrentSubject ? 20.sp : 17.sp,
                      color: Colors.white.withValues(alpha: 0.96),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SubjectLeadingImage extends StatelessWidget {
  const _SubjectLeadingImage({
    required this.subject,
    required this.softAccentColor,
    required this.accentColor,
  });

  final SubjectEntity subject;
  final Color softAccentColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (subject.image ?? '').trim();
    final hasNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.42),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.r),
        child: hasNetworkImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackImage(),
              )
            : _buildFallbackImage(),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: softAccentColor,
      alignment: Alignment.center,
      child: Icon(
        Symbols.book_rounded,
        color: accentColor,
        size: 24.sp,
      ),
    );
  }
}
