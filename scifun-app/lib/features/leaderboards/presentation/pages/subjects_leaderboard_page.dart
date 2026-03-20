import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/leaderboards/presentation/cubit/leaderboards_cubit.dart';
import 'package:sci_fun/features/leaderboards/presentation/pages/leaderboard_page.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class SubjectsLeaderboardPage extends StatefulWidget {
  const SubjectsLeaderboardPage({super.key});

  @override
  State<SubjectsLeaderboardPage> createState() =>
      _SubjectsLeaderboardPageState();
}

class _SubjectsLeaderboardPageState extends State<SubjectsLeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: '🏆 Bảng xếp hạng',
        rightIcon: GestureDetector(
          onTap: () => context.read<SubjectCubit>().refresh(),
          child: Icon(
            Icons.refresh,
            color: AppColor.skyblue600,
            size: 24,
          ),
        ),
        showBack: false,
      ),
      body: BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
        builder: (context, state) {
          if (state is PaginationLoading<SubjectEntity> &&
              state.items.isEmpty) {
            return const Center(
              child: AppLoadingIndicator(
                message: 'Đang tải bảng xếp hạng...',
              ),
            );
          }

          if (state is PaginationError<SubjectEntity> && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Lỗi khi tải bảng xếp hạng: ${state.error}'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.read<SubjectCubit>().refresh(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return const Center(
              child: AppEmptyState(message: 'Chưa có dữ liệu bảng xếp hạng'),
            );
          }

          return ListView.builder(
            itemCount: state.items.length,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemBuilder: (context, index) {
              final subject = state.items[index];
              return _SubjectLeaderboardCard(subject: subject);
            },
          );
        },
      ),
    );
  }
}

class _SubjectLeaderboardCard extends StatelessWidget {
  const _SubjectLeaderboardCard({required this.subject});

  final SubjectEntity subject;

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColor.subject500(subject.name);
    final pressedAccentColor = AppColor.subject600(subject.name);
    final softAccentColor = AppColor.subject100(subject.name);
    final imageUrl = (subject.image ?? '').trim();
    final hasImage = imageUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BasicButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => sl<LeaderboardsCubit>(),
                child: LeaderboardPage(
                  subjectId: subject.id ?? '',
                  subjectName: subject.name,
                ),
              ),
            ),
          );
        },
        width: double.infinity,
        height: 112,
        borderRadius: BorderRadius.circular(12),
        backgroundColor: accentColor,
        buttonColor: pressedAccentColor,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _FallbackSubjectImage(
                      softAccentColor: softAccentColor,
                      pressedAccentColor: pressedAccentColor,
                    );
                  },
                ),
              )
            else
              _FallbackSubjectImage(
                softAccentColor: softAccentColor,
                pressedAccentColor: pressedAccentColor,
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name ?? 'Tên môn',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject.description ?? 'Không có mô tả',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackSubjectImage extends StatelessWidget {
  const _FallbackSubjectImage({
    required this.softAccentColor,
    required this.pressedAccentColor,
  });

  final Color softAccentColor;
  final Color pressedAccentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: softAccentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.book,
        color: pressedAccentColor,
      ),
    );
  }
}
