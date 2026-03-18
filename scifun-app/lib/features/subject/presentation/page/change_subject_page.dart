import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
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
              .toList();

          if (subjects.isEmpty) {
            return const Center(child: Text('Không có môn học'));
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            itemCount: subjects.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (_, index) {
              final subject = subjects[index];
              final subjectName = subject.name?.trim().isNotEmpty == true
                  ? subject.name!.trim()
                  : 'Môn học';

              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  side: BorderSide(
                    color: AppColor.skyblue600.withValues(alpha: 0.25),
                  ),
                ),
                leading: _SubjectLeadingImage(subject: subject),
                title: Text(
                  subjectName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: (subject.description ?? '').trim().isEmpty
                    ? null
                    : Text(
                        subject.description!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: Colors.black54,
                ),
                onTap: () async {
                  final subjectId = subject.id ?? '';
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
  });

  final SubjectEntity subject;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (subject.image ?? '').trim();
    final hasNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 44.w,
        height: 44.w,
        color: AppColor.skyblue600.withValues(alpha: 0.12),
        child: hasNetworkImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.book_rounded),
              )
            : const Icon(Icons.book_rounded),
      ),
    );
  }
}
