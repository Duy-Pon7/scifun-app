import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

sealed class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? error;
  final int currentPage;
  final String searchQuery;
  final String? filterId; // ID để filter (categoryId, userId, etc.)

  PaginationState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.error,
    this.currentPage = 1,
    this.searchQuery = '',
    this.filterId,
  });
}

final class PaginationInitial<T> extends PaginationState<T> {
  PaginationInitial({super.searchQuery, super.filterId});
}

final class PaginationLoading<T> extends PaginationState<T> {
  PaginationLoading({super.searchQuery, super.filterId})
      : super(isLoading: true);
}

final class PaginationLoadingMore<T> extends PaginationState<T> {
  PaginationLoadingMore({
    required super.items,
    required super.currentPage,
    required super.searchQuery,
    super.filterId,
  }) : super(isLoadingMore: true);
}

final class PaginationSuccess<T> extends PaginationState<T> {
  PaginationSuccess({
    required super.items,
    required super.hasReachedEnd,
    required super.currentPage,
    required super.searchQuery,
    super.filterId,
  });
}

final class PaginationError<T> extends PaginationState<T> {
  PaginationError({
    required String super.error,
    super.items,
    required super.currentPage,
    required super.searchQuery,
    super.filterId,
  });
}

// CUBIT
abstract class PaginationCubit<T> extends Cubit<PaginationState<T>> {
  PaginationCubit({String? filterId})
      : super(PaginationInitial<T>(filterId: filterId));

  // Abstract method với search param và filterId
  Future<List<T>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  });

  final int pageSize = 10;
  Timer? _debounceTimer;

  Future<void> loadInitial({
    String searchQuery = '',
    String? filterId,
  }) async {
    // Luôn ưu tiên filterId truyền vào, không sử dụng state cũ
    final activeFilterId = filterId;

    emit(PaginationLoading<T>(
      searchQuery: searchQuery,
      filterId: activeFilterId,
    ));

    try {
      final items = await fetchData(
        1,
        pageSize,
        searchQuery: searchQuery,
        filterId: activeFilterId,
      );

      emit(PaginationSuccess<T>(
        items: items,
        hasReachedEnd: items.length < pageSize,
        currentPage: 1,
        searchQuery: searchQuery,
        filterId: activeFilterId,
      ));
    } catch (e) {
      emit(PaginationError<T>(
        error: e.toString(),
        currentPage: 0,
        searchQuery: searchQuery,
        filterId: activeFilterId,
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    emit(PaginationLoadingMore<T>(
      items: state.items,
      currentPage: state.currentPage,
      searchQuery: state.searchQuery,
      filterId: state.filterId,
    ));

    try {
      final newPage = state.currentPage + 1;
      final newItems = await fetchData(
        newPage,
        pageSize,
        searchQuery: state.searchQuery,
        filterId: state.filterId,
      );

      emit(PaginationSuccess<T>(
        items: [...state.items, ...newItems],
        hasReachedEnd: newItems.length < pageSize,
        currentPage: newPage,
        searchQuery: state.searchQuery,
        filterId: state.filterId,
      ));
    } catch (e) {
      emit(PaginationError<T>(
        error: e.toString(),
        items: state.items,
        currentPage: state.currentPage,
        searchQuery: state.searchQuery,
        filterId: state.filterId,
      ));
    }
  }

  // Search với debounce
  void search(
    String query, {
    Duration debounce = const Duration(milliseconds: 500),
    String? filterId,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () {
      loadInitial(searchQuery: query, filterId: filterId);
    });
  }

  // Đổi filter ID (ví dụ: đổi category)
  Future<void> changeFilter(String? newFilterId) async {
    await loadInitial(
      searchQuery: state.searchQuery,
      filterId: newFilterId,
    );
  }

  Future<void> refresh() async {
    await loadInitial(
      searchQuery: state.searchQuery,
      filterId: state.filterId,
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
