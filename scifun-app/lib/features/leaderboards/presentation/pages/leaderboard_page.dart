import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/domain/usecase/get_progress.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/presentation/cubit/leaderboards_cubit.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({
    super.key,
    required this.subjectId,
    this.subjectName,
  });

  final String subjectId;
  final String? subjectName;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late LeaderboardsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LeaderboardsCubit>();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant LeaderboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subjectId != widget.subjectId) {
      _loadData();
    }
  }

  void _loadData() {
    _cubit.loadLeaderboards(
      subjectId: widget.subjectId,
      period: 'alltime',
    );

    context
        .read<ProgressCubit>()
        .getProgress(ProgressParams(subjectId: widget.subjectId));
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = AppColor.subject600(widget.subjectName);
    final Color softAccent = AppColor.subject100(widget.subjectName);

    return Scaffold(
      appBar: BasicAppbar(
        title: '🏆 Bảng xếp hạng',
        showBack: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              softAccent.withValues(alpha: 0.64),
              Colors.white,
              Colors.white,
            ],
            stops: const [0, 0.2, 1],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: _LeaderboardHeader(
                accentColor: accentColor,
                subjectName: widget.subjectName,
              ),
            ),
            Expanded(
              child: PaginationListView<LeaderboardsEntity>(
                cubit: _cubit,
                emptyWidget: const Center(
                  child:
                      AppEmptyState(message: 'Chưa có dữ liệu bảng xếp hạng'),
                ),
                itemBuilder: (context, item) {
                  return _LeaderboardItem(
                    item: item,
                    accentColor: accentColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardHeader extends StatelessWidget {
  const _LeaderboardHeader({
    required this.accentColor,
    required this.subjectName,
  });

  final Color accentColor;
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    final bool hasSubject = (subjectName ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.emoji_events_rounded,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSubject
                      ? 'Top người học ${subjectName!.trim()}'
                      : 'Top người học',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Vuốt xuống để làm mới bảng xếp hạng',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'LIVE',
              style: TextStyle(
                color: accentColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  const _LeaderboardItem({
    required this.item,
    required this.accentColor,
  });

  final LeaderboardsEntity item;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final int rank = item.rank ?? 0;
    final bool isTopThree = rank > 0 && rank <= 3;
    final Color rankColor = _rankColor(rank);
    final Color dominantColor = isTopThree ? rankColor : accentColor;
    final String userName = _displayName(item.userName);
    final int progress = (item.progress ?? 0).clamp(0, 100).toInt();
    final String scoreLabel = _formatScore(item.totalScore ?? 0);
    final int completedTopics = item.completedTopics ?? 0;
    final int completedQuizzes = item.completedQuizzes ?? 0;
    final int? rankTrend =
        _rankTrend(currentRank: rank, previousRank: item.previousRank);
    final int delaySeed = rank <= 0 ? 1 : rank.clamp(1, 18).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 260 + (delaySeed * 28)),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 14),
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isTopThree
                  ? [
                      rankColor.withValues(alpha: 0.16),
                      Colors.white,
                    ]
                  : [
                      Colors.white,
                      accentColor.withValues(alpha: 0.04),
                    ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isTopThree
                  ? rankColor.withValues(alpha: 0.5)
                  : accentColor.withValues(alpha: 0.18),
              width: isTopThree ? 1.2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    dominantColor.withValues(alpha: isTopThree ? 0.18 : 0.08),
                blurRadius: isTopThree ? 18 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RankBadge(
                  rank: rank,
                  accentColor: accentColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: isTopThree ? 19 : 17,
                                color: const Color(0xFF111827),
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          _RankPill(rank: rank, color: rankColor),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MetricChip(
                            icon: Symbols.stars_rounded,
                            label: 'Điểm $scoreLabel',
                            textColor: const Color(0xFF1F2937),
                            backgroundColor:
                                Colors.black.withValues(alpha: 0.06),
                          ),
                          _MetricChip(
                            icon: Symbols.bolt_rounded,
                            label: 'Tiến độ $progress%',
                            textColor: accentColor,
                            backgroundColor:
                                accentColor.withValues(alpha: 0.14),
                          ),
                          if (rankTrend != null && rankTrend != 0)
                            _RankTrendChip(rankTrend: rankTrend),
                        ],
                      ),
                      if (progress > 0) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            minHeight: 7,
                            backgroundColor:
                                accentColor.withValues(alpha: 0.12),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(dominantColor),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Chủ đề: $completedTopics  •  Quiz: $completedQuizzes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _displayName(String? value) {
    final String trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return 'Người dùng ẩn danh';
    }
    return trimmed;
  }

  String _formatScore(double score) {
    if (score == score.roundToDouble()) {
      return score.toStringAsFixed(0);
    }
    return score.toStringAsFixed(2);
  }

  int? _rankTrend({required int currentRank, required int? previousRank}) {
    if (previousRank == null || currentRank <= 0 || previousRank <= 0) {
      return null;
    }
    return previousRank - currentRank;
  }

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFB800);
    if (rank == 2) return const Color(0xFF9CA3AF);
    if (rank == 3) return const Color(0xFFB26D4F);
    return accentColor;
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankTrendChip extends StatelessWidget {
  const _RankTrendChip({required this.rankTrend});

  final int rankTrend;

  @override
  Widget build(BuildContext context) {
    final bool isUp = rankTrend > 0;
    final int step = rankTrend.abs();
    final Color chipColor =
        isUp ? const Color(0xFF1A9C5B) : const Color(0xFFCF3A3A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Symbols.trending_up_rounded : Symbols.trending_down_rounded,
            size: 14,
            color: chipColor,
          ),
          const SizedBox(width: 5),
          Text(
            isUp ? '+$step hạng' : '-$step hạng',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankPill extends StatelessWidget {
  const _RankPill({
    required this.rank,
    required this.color,
  });

  final int rank;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        rank > 0 ? '#$rank' : '--',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({
    required this.rank,
    required this.accentColor,
  });

  final int rank;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final bool isTopThree = rank > 0 && rank <= 3;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isTopThree
              ? [
                  _color,
                  _color.withValues(alpha: 0.76),
                ]
              : [
                  accentColor.withValues(alpha: 0.2),
                  accentColor.withValues(alpha: 0.36),
                ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _color.withValues(alpha: 0.24),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isTopThree
          ? const Icon(
              Symbols.emoji_events_rounded,
              color: Colors.white,
              size: 28,
            )
          : Center(
              child: Text(
                rank > 0 ? '$rank' : '-',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }

  Color get _color {
    switch (rank) {
      case 1:
        return const Color(0xFFFFB800);
      case 2:
        return const Color(0xFF9CA3AF);
      case 3:
        return const Color(0xFFB26D4F);
      default:
        return accentColor;
    }
  }
}
