part of 'paginator_cubit.dart';

sealed class PaginatorState<T> {}

final class PaginatorInitial<T> extends PaginatorState<T> {}

final class PaginatorLoading<T> extends PaginatorState<T> {}

final class PaginatorLoadMore<T> extends PaginatorState<T> {}

final class PaginatorLoaded<T> extends PaginatorState<T> {}

final class PaginatorFailed<T> extends PaginatorState<T> {
  final String message;

  PaginatorFailed({required this.message});
}
