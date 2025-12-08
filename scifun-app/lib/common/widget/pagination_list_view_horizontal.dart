import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';

// Phiên bản ngang
class PaginationListViewHorizontal<T> extends StatefulWidget {
  final PaginationCubit<T> cubit;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final double? height; // Chiều cao của ListView ngang

  const PaginationListViewHorizontal({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    this.emptyWidget,
    this.errorWidget,
    this.height,
  });

  @override
  State<PaginationListViewHorizontal<T>> createState() =>
      _PaginationListViewHorizontalState<T>();
}

class _PaginationListViewHorizontalState<T>
    extends State<PaginationListViewHorizontal<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.cubit.loadInitial();
  }

  void _onScroll() {
    if (_isEnd) {
      widget.cubit.loadMore();
    }
  }

  bool get _isEnd {
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
          return SizedBox(
            height: widget.height ?? 150,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Error on first load
        if (state is PaginationError && state.items.isEmpty) {
          return SizedBox(
            height: widget.height ?? 150,
            child: widget.errorWidget ??
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
                ),
          );
        }

        // Empty state
        if (state.items.isEmpty) {
          return SizedBox(
            height: widget.height ?? 150,
            child: widget.emptyWidget ??
                const Center(child: Text('No items found')),
          );
        }

        // Success with data
        return SizedBox(
          height: widget.height ?? 150,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal, // Cuộn ngang
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
