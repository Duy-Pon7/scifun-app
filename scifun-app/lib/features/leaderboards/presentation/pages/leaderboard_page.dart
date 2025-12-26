import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/domain/usecase/get_progress.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/presentation/cubit/leaderboards_cubit.dart';

class LeaderboardPage extends StatefulWidget {
  final String subjectId;

  const LeaderboardPage({
    super.key,
    required this.subjectId,
  });

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late LeaderboardsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LeaderboardsCubit>();

    // Load lần đầu
    _cubit.loadLeaderboards(
      subjectId: widget.subjectId,
      period: 'alltime',
    );

    // Load progress cho môn học này
    context
        .read<ProgressCubit>()
        .getProgress(ProgressParams(subjectId: widget.subjectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: '🏆 Bảng xếp hạng',
        rightIcon: GestureDetector(
            onTap: () => _cubit.refresh(),
            child: Icon(
              Icons.refresh,
              color: AppColor.primary600,
              size: 24,
            )),
        showBack: true,
      ),
      body: PaginationListView<LeaderboardsEntity>(
        cubit: _cubit,
        emptyWidget: const Center(
          child: Text('Chưa có dữ liệu bảng xếp hạng'),
        ),
        itemBuilder: (context, item) {
          return _LeaderboardItem(item: item);
        },
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final LeaderboardsEntity item;

  const _LeaderboardItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: _RankBadge(rank: item.rank ?? 0),
        title: Text(
          item.userName ?? 'Người dùng ẩn danh',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Điểm: ${item.totalScore}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 12),
                if (item.progress != null)
                  Text(
                    'Tiến độ: ${item.progress}%',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.primary600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Text(
          '#${item.rank}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _rankColor(item.rank ?? 0),
          ),
        ),
      ),
    );
  }

  Color _rankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey;
    if (rank == 3) return Colors.brown;
    return Colors.blueGrey;
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    if (rank > 3) {
      return CircleAvatar(
        backgroundColor: Colors.blueGrey.shade100,
        child: Text('$rank'),
      );
    }

    return CircleAvatar(
      backgroundColor: _color,
      child: Icon(
        Icons.emoji_events,
        color: Colors.white,
      ),
    );
  }

  Color get _color {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }
}
