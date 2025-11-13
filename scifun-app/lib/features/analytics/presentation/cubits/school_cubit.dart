import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/analytics/domain/entities/school_scores_entity.dart';
import 'package:thilop10_3004/features/analytics/domain/usecase/get_school.dart';

/// --- STATE ---
sealed class SchoolState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final SchoolScoresEntity school;

  SchoolLoaded(this.school);

  @override
  List<Object?> get props => [school];
}

class SchoolError extends SchoolState {
  final String message;

  SchoolError(this.message);

  @override
  List<Object?> get props => [message];
}

/// --- CUBIT ---
class SchoolCubit extends Cubit<SchoolState> {
  final GetSchool getSchool;

  // ✅ Sửa lại kiểu đúng
  SchoolScoresEntity? _school;

  SchoolCubit(this.getSchool) : super(SchoolInitial());

  Future<void> fetchSchools() async {
    if (isClosed) return;

    emit(SchoolLoading());

    final result = await getSchool(NoParams());

    result.fold(
      (failure) => emit(SchoolError(failure.message)),
      (school) {
        _school = school;
        emit(SchoolLoaded(school));
      },
    );
  }

  SchoolScoresEntity? get school => _school;
}
