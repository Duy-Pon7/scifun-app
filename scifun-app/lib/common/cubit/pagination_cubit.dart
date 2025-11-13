import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

sealed class PaginationState<T> {}

final class PaginationInitial<T> extends PaginationState<T> {}

final class PaginationLoading<T> extends PaginationState<T> {}

final class PaginationLoadMore<T> extends PaginationState<T> {}

final class PaginationLoaded<T> extends PaginationState<T> {}

final class PaginationFailed<T> extends PaginationState<T> {
  final String message;

  PaginationFailed({required this.message});
}

class PaginationCubit<T, Param> extends Cubit<PaginationState<T>> {
  final Usecase<List<T>, PaginationParam<Param>> _usecase;
  final int _limit;

  PaginationCubit({
    required Usecase<List<T>, PaginationParam<Param>> usecase,
    int limit = 10,
  })  : _usecase = usecase,
        _limit = limit,
        super(PaginationInitial<T>());

  bool _isLastPage = false;
  bool get isLastPage => _isLastPage;
  int _currentPage = 1;
  List<T> _items = [];

  List<T> get items => _items;

  // Paginate data
  Future<void> paginateData({Param? param}) async {
    final currentState = state;
    if (currentState is PaginationLoading<T> ||
        currentState is PaginationLoadMore<T> ||
        (currentState is PaginationLoaded<T> && _isLastPage)) {
      return;
    }

    _currentPage == 1
        ? emit(PaginationLoading<T>())
        : emit(PaginationLoadMore<T>());

    final res = await _usecase.call(PaginationParam<Param>(
      page: _currentPage,
      param: param,
    ));

    res.fold(
      (failure) {
        print(failure.message);
        emit(PaginationFailed<T>(message: failure.message));
      },
      (data) {
        _isLastPage = data.length < _limit;
        _currentPage++;
        _items.addAll(data);
        emit(PaginationLoaded<T>());
      },
    );
  }

  // Refresh data
  Future<void> refreshData({Param? param}) async {
    emit(PaginationInitial<T>());
    _isLastPage = false;
    _currentPage = 1;
    _items.clear();
    paginateData(param: param);
  }
}
