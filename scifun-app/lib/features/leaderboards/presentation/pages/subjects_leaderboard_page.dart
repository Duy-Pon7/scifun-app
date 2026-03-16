import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
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
                AppColor.skyblue600.withValues(alpha: 0.1),
                AppColor.skyblue600.withValues(alpha: 0.05),
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
                              color: AppColor.skyblue600.withValues(alpha: 0.2),
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
                        color: AppColor.skyblue600.withValues(alpha: 0.2),
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
                    color: AppColor.skyblue600,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
