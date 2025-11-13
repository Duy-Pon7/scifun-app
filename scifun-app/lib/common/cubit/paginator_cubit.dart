import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';

part 'paginator_state.dart';

class PaginatorCubit<T, Param> extends Cubit<PaginatorState<T>> {
  final Usecase<List<T>, PaginationParam<Param>> _usecase;
  final int _limit;

  PaginatorCubit({
    required Usecase<List<T>, PaginationParam<Param>> usecase,
    int limit = 10,
  })  : _usecase = usecase,
        _limit = limit,
        super(PaginatorInitial<T>());

  bool _isLastPage = false;
  int _currentPage = 1;
  List<T> _items = [];

  List<T> get items => _items;

  // Paginate data
  Future<void> paginateData({Param? param}) async {
    final currentState = state;
    if (currentState is PaginatorLoading<T> ||
        currentState is PaginatorLoadMore<T> ||
        (currentState is PaginatorLoaded<T> && _isLastPage)) {
      return;
    }

    _currentPage == 1
        ? emit(PaginatorLoading<T>())
        : emit(PaginatorLoadMore<T>());
    final res = await _usecase.call(PaginationParam<Param>(
      page: _currentPage,
      param: param,
    ));

    res.fold(
      (failure) {
        emit(PaginatorFailed<T>(message: failure.message));
      },
      (data) {
        _isLastPage = data.length < _limit;
        _currentPage++;
        _items.addAll(data);
        emit(PaginatorLoaded<T>());
      },
    );
  }

  // Refresh data
  Future<void> refreshData({Param? param}) async {
    emit(PaginatorInitial<T>());
    _isLastPage = false;
    _currentPage = 1;
    _items.clear();
    paginateData(param: param);
  }
}
