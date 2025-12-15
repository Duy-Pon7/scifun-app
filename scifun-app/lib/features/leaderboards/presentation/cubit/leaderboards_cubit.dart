import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/domain/usecase/get_all_leaderboards.dart';
import 'package:sci_fun/features/leaderboards/domain/usecase/rebuild_leaderboard.dart';

class LeaderboardsCubit extends PaginationCubit<LeaderboardsEntity> {
  final GetLeaderboard getLeaderboard;
  final RebuildLeaderboard rebuildLeaderboard;

  LeaderboardsCubit({
    required this.getLeaderboard,
    required this.rebuildLeaderboard,
    String? subjectId,
  }) : super(filterId: subjectId);

  String _period = 'alltime';

  /// =======================
  /// FETCH DATA (PHÂN TRANG)
  /// =======================
  @override
  Future<List<LeaderboardsEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId, // subjectId
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

  /// =======================
  /// LOAD FIRST PAGE
  /// =======================
  Future<void> loadLeaderboards({
    required String subjectId,
    String period = 'alltime',
  }) async {
    _period = period;

    await loadInitial(
      filterId: subjectId,
    );
  }

  /// =======================
  /// REBUILD + REFRESH
  /// =======================
  Future<void> rebuildAndRefresh({
    required String subjectId,
    String period = 'alltime',
  }) async {
    _period = period;

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
        // debug log
        try {
          print(
              'Rebuild result: subjectId=${result.subjectId}, period=${result.period}, updated=${result.updated}, notified=${result.notified}');
        } catch (_) {}
        try {
          // If server reported updates, wait a bit for the background job
          // to finish so that subsequent GET returns updated data.
          if (result.updated > 0) {
            await Future.delayed(const Duration(milliseconds: 1500));
          }
        } catch (_) {}

        await refresh(); // load lại trang 1
      },
    );
  }
}
