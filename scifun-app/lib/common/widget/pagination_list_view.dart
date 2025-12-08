import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';

// Phiên bản dọc
class PaginationListView<T> extends StatefulWidget {
  final PaginationCubit<T> cubit;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget? emptyWidget;
  final Widget? errorWidget;

  const PaginationListView({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    this.emptyWidget,
    this.errorWidget,
  });

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Không gọi loadInitial() ở đây - để parent/cubit xử lý
  }

  void _onScroll() {
    if (_isBottom) {
      widget.cubit.loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationCubit<T>, PaginationState<T>>(
      bloc: widget.cubit,
      builder: (context, state) {
        // Initial loading
        if (state is PaginationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error on first load
        if (state is PaginationError && state.items.isEmpty) {
          return widget.errorWidget ??
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () => widget.cubit.loadInitial(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
        }

        // Empty state
        if (state.items.isEmpty) {
          return widget.emptyWidget ??
              const Center(child: Text('No items found'));
        }

        // Success with data
        return RefreshIndicator(
          onRefresh: () => widget.cubit.refresh(),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.items.length + (state.hasReachedEnd ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                // Load more indicator
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return widget.itemBuilder(context, state.items[index]);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
