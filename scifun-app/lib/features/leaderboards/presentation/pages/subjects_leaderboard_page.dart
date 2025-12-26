import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
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
              color: AppColor.primary600,
              size: 24,
            )),
        showBack: false,
      ),
      body: BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
        builder: (context, state) {
          if (state.items.isEmpty && state.currentPage == 1) {
            return const Center(
              child: CircularProgressIndicator(),
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
  final SubjectEntity subject;

  const _SubjectLeaderboardCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => sl<LeaderboardsCubit>(),
              child: LeaderboardPage(subjectId: subject.id ?? ''),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColor.primary600.withOpacity(0.1),
                AppColor.primary600.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với image và tên môn
              Row(
                children: [
                  // Image
                  if (subject.image != null && subject.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        subject.image!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColor.primary600.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.book),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColor.primary600.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.book),
                    ),
                  const SizedBox(width: 16),
                  // Tên môn và mô tả
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name ?? 'Tên môn',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject.description ?? 'Không có mô tả',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.primary600,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              _ProgressSection(maxTopics: subject.maxTopics ?? 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final int maxTopics;

  const _ProgressSection({required this.maxTopics});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        // Lấy progress từ cubit
        int completedTopics = 0;
        double progressPercent = 0;

        if (state is ProgressLoaded) {
          // Nếu có dữ liệu progress, tính toán dựa trên dữ liệu đó
          completedTopics = state.progress.completedTopics ?? 0;
          progressPercent =
              maxTopics > 0 ? (completedTopics / maxTopics).clamp(0.0, 1.0) : 0;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ học tập',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '$completedTopics/$maxTopics',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercent,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColor.primary600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progressPercent * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        );
      },
    );
  }
}
