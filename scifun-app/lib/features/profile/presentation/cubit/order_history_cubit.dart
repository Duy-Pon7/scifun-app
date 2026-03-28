import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/order_history_entity.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_order_history.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  const OrderHistoryLoaded({
    required this.orders,
    required this.page,
    required this.totalPages,
    required this.total,
    this.isLoadingMore = false,
  });

  final List<UserOrderEntity> orders;
  final int page;
  final int totalPages;
  final int total;
  final bool isLoadingMore;

  bool get hasMore => page < totalPages;

  OrderHistoryLoaded copyWith({
    List<UserOrderEntity>? orders,
    int? page,
    int? totalPages,
    int? total,
    bool? isLoadingMore,
  }) {
    return OrderHistoryLoaded(
      orders: orders ?? this.orders,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        orders,
        page,
        totalPages,
        total,
        isLoadingMore,
      ];
}

class OrderHistoryError extends OrderHistoryState {
  const OrderHistoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({
    required this.getOrderHistory,
    int limit = 10,
  })  : _limit = limit,
        super(OrderHistoryInitial());

  final GetOrderHistory getOrderHistory;
  final int _limit;

  Future<void> fetchInitial() async {
    emit(OrderHistoryLoading());
    final result = await getOrderHistory(
      PaginationParam(
        page: 1,
        param: OrderHistoryParams(limit: _limit),
      ),
    );

    result.fold(
      (failure) => emit(OrderHistoryError(failure.message)),
      (history) => emit(
        OrderHistoryLoaded(
          orders: history.orders,
          page: history.page,
          totalPages: history.totalPages,
          total: history.total,
        ),
      ),
    );
  }

  Future<void> fetchMore() async {
    final currentState = state;
    if (currentState is! OrderHistoryLoaded) {
      return;
    }
    if (currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    final nextPage = currentState.page + 1;

    final result = await getOrderHistory(
      PaginationParam(
        page: nextPage,
        param: OrderHistoryParams(limit: _limit),
      ),
    );

    result.fold(
      (_) => emit(currentState.copyWith(isLoadingMore: false)),
      (history) => emit(
        currentState.copyWith(
          orders: [...currentState.orders, ...history.orders],
          page: history.page,
          totalPages: history.totalPages,
          total: history.total,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
