import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/subject/domain/entity/subject_entity.dart';
import 'package:thilop10_3004/features/subject/domain/usecase/get_all_subjects.dart';

sealed class SubjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectsLoaded extends SubjectState {
  final SubjectEntity subjectList;

  SubjectsLoaded(this.subjectList);

  @override
  List<Object?> get props => [subjectList];
}

class SubjectDetailLoaded extends SubjectState {
  final SubjectEntity subjectDetail;

  SubjectDetailLoaded(this.subjectDetail);

  @override
  List<Object?> get props => [subjectDetail];
}

class SubjectError extends SubjectState {
  final String message;

  SubjectError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubjectCubit extends Cubit<SubjectState> {
  final GetAllSubjects getAllSubjects;

  SubjectCubit({required this.getAllSubjects}) : super(SubjectInitial());

  Future<void> getSubjects() async {
    emit(SubjectLoading());
    try {
      final res = await getAllSubjects.call(NoParams());

      res.fold(
        (failure) => emit(SubjectError(failure.message)),
        (data) => emit(SubjectsLoaded(data)),
      );
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }
}
