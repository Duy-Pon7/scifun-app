import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thilop10_3004/features/analytics/domain/entities/school_data_entity.dart';
import 'package:thilop10_3004/features/analytics/domain/usecase/get_list_school_data.dart';

abstract class SchoolDataState extends Equatable {
  const SchoolDataState();

  @override
  List<Object?> get props => [];
}

class SchoolDataInitial extends SchoolDataState {}

class SchoolDataLoading extends SchoolDataState {}

class SchoolDataLoaded extends SchoolDataState {
  final List<SchoolDataEntity> schools;
  const SchoolDataLoaded(this.schools);

  @override
  List<Object?> get props => [schools];
}

class SchoolDataError extends SchoolDataState {
  final String message;
  const SchoolDataError(this.message);

  @override
  List<Object?> get props => [message];
}

class SchoolPaginatorCubit extends Cubit<SchoolDataState> {
  final GetListSchoolData getListSchoolData;

  SchoolPaginatorCubit(this.getListSchoolData) : super(SchoolDataInitial());

  Future<void> fetchSchoolData(int year, int provinceId) async {
    emit(SchoolDataLoading());
    final result = await getListSchoolData(
        SchoolQueryParam(provinceId: provinceId, year: year));

    result.fold(
      (failure) => emit(SchoolDataError(failure.message)),
      (data) => emit(SchoolDataLoaded(data)),
    );
  }
}
