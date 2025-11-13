import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/news_entity.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_all_news.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_news_detail.dart';

sealed class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> newsList;
  NewsLoaded(this.newsList);

  @override
  List<Object?> get props => [newsList];
}

class NewsDetailLoaded extends NewsState {
  final NewsEntity newsDetail;

  NewsDetailLoaded(this.newsDetail);

  @override
  List<Object?> get props => [newsDetail];
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsCubit extends Cubit<NewsState> {
  final GetAllNews getAllNews;
  final GetNewsDetail getNewsDetail;

  NewsCubit(this.getAllNews, this.getNewsDetail)
      : super(NewsInitial());

  Future<void> getNews() async {
    emit(NewsLoading());
    try {
      final res = await getAllNews
          .call(PaginationParam<void>(page: 1, param: null));
      res.fold(
        (failure) => emit(NewsError(failure.message)),
        (data) => emit(NewsLoaded(data)),
      );
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  /// ✅ Hàm mới để lấy chi tiết 1 tin tức
  Future<void> fetchNewsDetail({required int newsId}) async {
    emit(NewsLoading());
    try {
      final res = await getNewsDetail(newsId);
      res.fold(
        (failure) => emit(NewsError(failure.message)),
        (data) => emit(NewsDetailLoaded(data)),
      );
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
