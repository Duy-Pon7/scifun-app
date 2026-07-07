import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/domain/usecase/get_all_leaderboards.dart';
import 'package:sci_fun/features/leaderboards/domain/usecase/rebuild_leaderboard.dart';

class LeaderboardsCubit extends PaginationCubit<LeaderboardsEntity> {
  final GetLeaderboard getLeaderboard;
  final RebuildLeaderboard rebuildLeaderboard;
  bool _isRebuilding = false;

  LeaderboardsCubit({
    required this.getLeaderboard,
    required this.rebuildLeaderboard,
    String? subjectId,
  }) : super(filterId: subjectId);

  String _period = 'alltime';

  @override
  Future<List<LeaderboardsEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    final res = await getLeaderboard(
      GetLeaderboardParams(
        subjectId: filterId ?? '',
        page: page,
        limit: limit,
        period: _period,
      ),
    );

    return res.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> loadLeaderboards({
    required String subjectId,
    String period = 'alltime',
  }) async {
    _period = period;

    await loadInitial(
      filterId: subjectId,
    );
  }

  Future<void> rebuildAndRefresh({
    required String subjectId,
    String period = 'alltime',
  }) async {
    if (_isRebuilding) return;

    _period = period;
    _isRebuilding = true;

    try {
      final res = await rebuildLeaderboard(
        RebuildLeaderboardParams(subjectId: subjectId),
      );

      await res.fold(
        (failure) async {
          emit(
            PaginationError<LeaderboardsEntity>(
              error: failure.message,
              items: state.items,
              currentPage: state.currentPage,
              searchQuery: state.searchQuery,
              filterId: subjectId,
            ),
          );
        },
        (result) async {
          logApiSuccess(
            source: 'LeaderboardsCubit.rebuildAndRefresh',
            data: {
              'subjectId': result.subjectId,
              'period': result.period,
              'updated': result.updated,
              'notified': result.notified,
            },
          );

          try {
            if (result.updated > 0) {
              await Future.delayed(const Duration(milliseconds: 1500));
            }
          } catch (_) {}

          await super.refresh();
        },
      );
    } finally {
      _isRebuilding = false;
    }
  }

  @override
  Future<void> refresh() async {
    final subjectId = state.filterId;
    if (subjectId == null || subjectId.isEmpty) {
      await super.refresh();
      return;
    }

    await rebuildAndRefresh(
      subjectId: subjectId,
      period: _period,
    );
  }
}
