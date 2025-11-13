import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/home/domain/entity/lesson_category_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/lesson_entity.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_lesson_category.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_lesson_detail.dart';

sealed class LessonState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonDetailLoaded extends LessonState {
  final LessonEntity lessonEntity;

  LessonDetailLoaded(this.lessonEntity);

  @override
  List<Object?> get props => [lessonEntity];
}

class LessonError extends LessonState {
  final String message;

  LessonError(this.message);

  @override
  List<Object?> get props => [message];
}

class LessonCategoryLoading extends LessonState {}

class LessonCategoryLoaded extends LessonState {
  final List<LessonCategoryEntity> categories;

  LessonCategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class LessonCategoryError extends LessonState {
  final String message;

  LessonCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class LessonCubit extends Cubit<LessonState> {
  final GetLessonDetail getLessonDetail;
  final GetLessonCategory getLessonCategory; // Thêm usecase này

  LessonCubit(
    this.getLessonDetail,
    this.getLessonCategory,
  ) : super(LessonInitial());

  Future<void> getLesson({required int lessonId}) async {
    emit(LessonLoading());
    try {
      final res = await getLessonDetail.call(lessonId);
      res.fold(
        (failure) => emit(LessonError(failure.message)),
        (data) => emit(LessonDetailLoaded(data)),
      );
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }

  Future<void> getLessonCategories(
      {required int subjectId, int page = 1}) async {
    emit(LessonCategoryLoading());
    try {
      final res = await getLessonCategory.call(
        PaginationParam(
            param: GetLessonCateParam(subjectId: subjectId), page: page),
      );
      res.fold(
        (failure) => emit(LessonCategoryError(failure.message)),
        (data) => emit(LessonCategoryLoaded(data)),
      );
    } catch (e) {
      emit(LessonCategoryError(e.toString()));
    }
  }
}
