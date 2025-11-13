import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/common/entities/settings_entity.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/profile/domain/entities/faqs_entity.dart';
import 'package:thilop10_3004/features/profile/domain/usecase/get_faqs.dart';
import 'package:thilop10_3004/features/profile/domain/usecase/get_settings.dart';

sealed class FaqsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FaqsInitial extends FaqsState {}

class FaqsLoading extends FaqsState {}

class FaqsLoaded extends FaqsState {
  final List<FaqsEntity> newsList;
  FaqsLoaded(this.newsList);

  @override
  List<Object?> get props => [newsList];
}

class FaqsDetailLoaded extends FaqsState {
  final FaqsEntity newsDetail;

  FaqsDetailLoaded(this.newsDetail);

  @override
  List<Object?> get props => [newsDetail];
}

class FaqsError extends FaqsState {
  final String message;

  FaqsError(this.message);

  @override
  List<Object?> get props => [message];
}

class FaqsCubit extends Cubit<FaqsState> {
  final GetFaqs getAllFaqs;

  FaqsCubit(this.getAllFaqs) : super(FaqsInitial());

  Future<void> getFaqs() async {
    emit(FaqsLoading());
    try {
      final res = await getAllFaqs.call(NoParams());
      res.fold(
        (failure) => emit(FaqsError(failure.message)),
        (data) =>
            emit(FaqsLoaded(data.whereType<FaqsEntity>().toList())),
      );
    } catch (e) {
      emit(FaqsError(e.toString()));
    }
  }
}
